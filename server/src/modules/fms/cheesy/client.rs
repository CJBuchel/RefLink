use std::{collections::HashMap, time::Duration};

use futures_util::{SinkExt, StreamExt};
use tokio::sync::{broadcast, mpsc, watch};
use tokio_tungstenite::{connect_async, tungstenite::Message, tungstenite::client::IntoClientRequest};

use crate::{
  core::{
    events::{ChangeEvent, EVENT_BUS},
    shutdown::ShutdownNotifier,
  },
  generated::{
    common::{MatchPhase, MatchType, TeamAllianceStationType},
    fms::{FmsConnectionStatus, FmsMatchInfo, FmsTeamState},
  },
  modules::fms::repository::FmsStateRepository,
};

use super::messages::{
  CheesyArenaStatus, CheesyMatchLoad, CheesyMatchTime, CheesyMatchTiming, MATCH_TYPE_PLAYOFF, MATCH_TYPE_PRACTICE,
  MATCH_TYPE_QUALIFICATION, STATE_AUTO_PERIOD, STATE_PAUSE_PERIOD, STATE_POST_MATCH, STATE_POST_TIMEOUT,
  STATE_TELEOP_PERIOD, STATE_TIMEOUT_ACTIVE,
};

#[derive(Clone)]
pub struct CheesyConfig {
  pub host: String,
  pub port: u16,
  pub display_id: u32,
  pub admin_password: Option<String>,
}

pub async fn run(config: CheesyConfig) {
  let shutdown = ShutdownNotifier::get();
  let (match_info_tx, match_info_rx) = watch::channel::<Option<FmsMatchInfo>>(None);
  let (cmd_tx, cmd_rx) = mpsc::channel::<Message>(64);

  tokio::join!(
    run_field_monitor(config.clone(), match_info_tx, shutdown.subscribe()),
    run_referee_panel(config.clone(), cmd_rx, shutdown.subscribe()),
    super::sync::run(match_info_rx, cmd_tx, shutdown.subscribe()),
  );
}

// --- Field monitor (read-only, unauthenticated) ---

#[derive(Default, Clone)]
struct StationState {
  team_id: Option<u32>,
  bypass: bool,
  e_stop: bool,
  a_stop: bool,
}

#[derive(Default)]
struct Accumulator {
  match_id: i32,
  match_number: i32,
  match_type: i32,
  match_state: i32,
  match_time_sec: i32,
  timing: CheesyMatchTiming,
  stations: HashMap<String, StationState>,
}

const STATION_ORDER: [&str; 6] = ["R1", "R2", "R3", "B1", "B2", "B3"];

impl Accumulator {
  fn merge_arena_status(&mut self, s: CheesyArenaStatus) {
    self.match_id = s.match_id;
    self.match_state = s.match_state;
    for (key, cs) in s.alliance_stations {
      let entry = self.stations.entry(key).or_default();
      entry.team_id = cs.team.map(|t| t.id).or(entry.team_id);
      entry.bypass = cs.bypass;
      entry.e_stop = cs.e_stop;
      entry.a_stop = cs.a_stop;
    }
  }

  fn merge_match_load(&mut self, s: CheesyMatchLoad) {
    self.match_id = s.match_.id;
    self.match_number = s.match_.type_order;
    self.match_type = s.match_.match_type;
    for (key, team) in s.teams {
      let entry = self.stations.entry(key).or_default();
      entry.team_id = team.map(|t| t.id);
    }
  }

  fn merge_match_time(&mut self, s: CheesyMatchTime) {
    self.match_state = s.match_state;
    self.match_time_sec = s.match_time_sec;
  }

  fn to_fms_match_info(&self) -> FmsMatchInfo {
    let (match_phase, time_remaining_sec) = map_match_phase(self.match_state, self.match_time_sec, &self.timing);

    let teams = STATION_ORDER
      .iter()
      .filter_map(|&key| {
        let station = self.stations.get(key)?;
        let alliance_station = map_station_key(key)?;
        Some(FmsTeamState {
          alliance_station: alliance_station as i32,
          team_number: station.team_id.unwrap_or(0) as i32,
          bypassed: station.bypass,
          estop: station.e_stop,
          astop: station.a_stop,
        })
      })
      .collect();

    FmsMatchInfo {
      match_id: self.match_id,
      match_number: self.match_number,
      match_type: map_match_type(self.match_type) as i32,
      match_phase: match_phase as i32,
      time_remaining_sec,
      teams,
    }
  }
}

fn map_station_key(key: &str) -> Option<TeamAllianceStationType> {
  match key {
    "R1" => Some(TeamAllianceStationType::Red1),
    "R2" => Some(TeamAllianceStationType::Red2),
    "R3" => Some(TeamAllianceStationType::Red3),
    "B1" => Some(TeamAllianceStationType::Blue1),
    "B2" => Some(TeamAllianceStationType::Blue2),
    "B3" => Some(TeamAllianceStationType::Blue3),
    _ => None,
  }
}

fn map_match_type(t: i32) -> MatchType {
  match t {
    MATCH_TYPE_PRACTICE => MatchType::Practice,
    MATCH_TYPE_QUALIFICATION => MatchType::Qualification,
    MATCH_TYPE_PLAYOFF => MatchType::Playoff,
    // Cheesy Arena's "Test" match type has no RefLink equivalent.
    _ => MatchType::Unspecified,
  }
}

// Cheesy Arena never signals an explicit "endgame" sub-phase at the arena level - it's
// purely the last `timing.endgame_duration_sec` of TeleopPeriod - so it's derived here from
// the remaining teleop time instead.
fn map_match_phase(state: i32, elapsed: i32, timing: &CheesyMatchTiming) -> (MatchPhase, i32) {
  let auto_end = timing.auto_duration_sec;
  let teleop_window = timing.pause_duration_sec + timing.teleop_duration_sec();

  match state {
    STATE_AUTO_PERIOD => (MatchPhase::Auto, (auto_end - elapsed).max(0)),
    STATE_PAUSE_PERIOD | STATE_TELEOP_PERIOD => {
      let teleop_elapsed = (elapsed - auto_end).max(0);
      let remaining = (teleop_window - teleop_elapsed).max(0);
      if remaining <= timing.endgame_duration_sec {
        (MatchPhase::Endgame, remaining)
      } else {
        (MatchPhase::Teleop, remaining)
      }
    }
    STATE_POST_MATCH | STATE_TIMEOUT_ACTIVE | STATE_POST_TIMEOUT => (MatchPhase::PostMatch, 0),
    // PreMatch, StartMatch, and any unrecognized state.
    _ => (MatchPhase::PreMatch, 0),
  }
}

fn process_field_message(raw: &str, acc: &mut Accumulator) -> bool {
  let Ok(v) = serde_json::from_str::<serde_json::Value>(raw) else { return false };
  let Some(msg_type) = v.get("type").and_then(|t| t.as_str()) else { return false };
  let Some(data) = v.get("data") else { return false };

  match msg_type {
    "arenaStatus" => match serde_json::from_value::<CheesyArenaStatus>(data.clone()) {
      Ok(s) => {
        acc.merge_arena_status(s);
        true
      }
      Err(e) => {
        log::warn!("[FMS] Failed to parse arenaStatus: {e}");
        false
      }
    },
    "matchLoad" => match CheesyMatchLoad::from_value(data) {
      Some(s) => {
        acc.merge_match_load(s);
        true
      }
      None => false,
    },
    "matchTime" => match serde_json::from_value::<CheesyMatchTime>(data.clone()) {
      Ok(s) => {
        acc.merge_match_time(s);
        true
      }
      Err(e) => {
        log::warn!("[FMS] Failed to parse matchTime: {e}");
        false
      }
    },
    "matchTiming" => match serde_json::from_value::<CheesyMatchTiming>(data.clone()) {
      Ok(s) => {
        acc.timing = s;
        false
      }
      Err(e) => {
        log::warn!("[FMS] Failed to parse matchTiming: {e}");
        false
      }
    },
    _ => false,
  }
}

async fn publish_match_info(info: FmsMatchInfo, tx: &watch::Sender<Option<FmsMatchInfo>>) {
  if let Err(e) = FmsMatchInfo::update_current(&info).await {
    log::warn!("[FMS] Failed to persist match info: {e}");
  }
  if let Some(bus) = EVENT_BUS.get() {
    let _ = bus.publish(ChangeEvent::Message { topic: "current".to_string(), data: info.clone() });
  }
  let _ = tx.send(Some(info));
}

fn publish_connection_status(connected: bool, config: &CheesyConfig, last_error: Option<String>) {
  let status = FmsConnectionStatus {
    connected,
    host: config.host.clone(),
    port: config.port as i32,
    last_error: last_error.unwrap_or_default(),
  };
  if let Some(bus) = EVENT_BUS.get() {
    let _ = bus.publish(ChangeEvent::Message { topic: "status".to_string(), data: status });
  }
}

async fn run_field_monitor(
  config: CheesyConfig,
  match_info_tx: watch::Sender<Option<FmsMatchInfo>>,
  mut shutdown_rx: broadcast::Receiver<()>,
) {
  let url = format!("ws://{}:{}/displays/field_monitor/websocket?displayId={}", config.host, config.port, config.display_id);
  let mut acc = Accumulator::default();
  let mut delay = Duration::from_secs(1);

  loop {
    log::info!("[FMS] Connecting to field monitor at {url}");
    let connect_result = tokio::select! {
      res = connect_async(&url) => res,
      _ = shutdown_rx.recv() => return,
    };

    match connect_result {
      Ok((mut ws, _)) => {
        log::info!("[FMS] Field monitor connected");
        delay = Duration::from_secs(1);
        publish_connection_status(true, &config, None);

        loop {
          tokio::select! {
            msg = ws.next() => {
              match msg {
                Some(Ok(Message::Text(text))) => {
                  if process_field_message(text.as_str(), &mut acc) {
                    publish_match_info(acc.to_fms_match_info(), &match_info_tx).await;
                  }
                }
                Some(Ok(Message::Close(_))) | None => break,
                Some(Err(e)) => {
                  log::warn!("[FMS] Field monitor error: {e}");
                  break;
                }
                _ => {}
              }
            }
            _ = shutdown_rx.recv() => return,
          }
        }

        log::warn!("[FMS] Field monitor disconnected");
        publish_connection_status(false, &config, Some("disconnected".to_string()));
      }
      Err(e) => {
        log::debug!("[FMS] Field monitor connect failed: {e}");
        publish_connection_status(false, &config, Some(e.to_string()));
      }
    }

    tokio::select! {
      _ = tokio::time::sleep(delay) => {}
      _ = shutdown_rx.recv() => return,
    }
    delay = (delay * 2).min(Duration::from_secs(10));
  }
}

// --- Referee panel (bidirectional, admin-gated) ---

async fn login(config: &CheesyConfig) -> anyhow::Result<Option<String>> {
  let Some(password) = &config.admin_password else { return Ok(None) };

  let url = format!("http://{}:{}/login", config.host, config.port);
  let client = reqwest::Client::builder().redirect(reqwest::redirect::Policy::none()).build()?;
  let params = [("username", "admin"), ("password", password.as_str())];

  // Cheesy Arena responds to a successful login with a 303 redirect carrying the session
  // cookie, so redirects must be disabled to observe the Set-Cookie header directly.
  let resp = client.post(&url).form(&params).send().await?;
  let cookie = resp
    .headers()
    .get(reqwest::header::SET_COOKIE)
    .and_then(|v| v.to_str().ok())
    .and_then(|raw| raw.split(';').next())
    .map(|s| s.to_string());

  match cookie {
    Some(c) => Ok(Some(c)),
    None => Err(anyhow::anyhow!("Cheesy Arena login did not return a session cookie (check admin password)")),
  }
}

async fn run_referee_panel(config: CheesyConfig, mut cmd_rx: mpsc::Receiver<Message>, mut shutdown_rx: broadcast::Receiver<()>) {
  let url = format!("ws://{}:{}/panels/referee/websocket", config.host, config.port);
  let mut delay = Duration::from_secs(1);

  loop {
    let cookie = match login(&config).await {
      Ok(c) => c,
      Err(e) => {
        log::warn!("[FMS] Referee panel login failed: {e}");
        None
      }
    };

    let mut request = match url.as_str().into_client_request() {
      Ok(r) => r,
      Err(e) => {
        log::error!("[FMS] Invalid referee panel URL: {e}");
        return;
      }
    };
    if let Some(cookie) = &cookie
      && let Ok(value) = cookie.parse()
    {
      request.headers_mut().insert(http::header::COOKIE, value);
    }

    log::info!("[FMS] Connecting to referee panel at {url}");
    let connect_result = tokio::select! {
      res = connect_async(request) => res,
      _ = shutdown_rx.recv() => return,
    };

    match connect_result {
      Ok((ws, _)) => {
        log::info!("[FMS] Referee panel connected");
        delay = Duration::from_secs(1);
        let (mut write, mut read) = ws.split();

        loop {
          tokio::select! {
            cmd = cmd_rx.recv() => {
              match cmd {
                Some(msg) => {
                  if let Err(e) = write.send(msg).await {
                    log::warn!("[FMS] Failed to send referee panel command: {e}");
                    break;
                  }
                }
                None => return, // sync engine has shut down
              }
            }
            msg = read.next() => {
              match msg {
                Some(Ok(Message::Close(_))) | None => break,
                Some(Err(e)) => {
                  log::warn!("[FMS] Referee panel error: {e}");
                  break;
                }
                _ => {}
              }
            }
            _ = shutdown_rx.recv() => return,
          }
        }

        log::warn!("[FMS] Referee panel disconnected");
      }
      Err(e) => log::debug!("[FMS] Referee panel connect failed: {e}"),
    }

    tokio::select! {
      _ = tokio::time::sleep(delay) => {}
      _ = shutdown_rx.recv() => return,
    }
    delay = (delay * 2).min(Duration::from_secs(10));
  }
}
