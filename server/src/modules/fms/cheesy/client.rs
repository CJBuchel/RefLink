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
    common::{FieldState, MatchPhase, MatchType, TeamAllianceStationType},
    db::MatchStateRecord,
    fms::{FmsConnectionStatus, FmsMatchInfo, FmsTeamState},
  },
  modules::{arena::MatchStateRepository, fms::repository::FmsStateRepository},
};

use super::messages::{
  CheesyArenaStatus, CheesyEventStatus, CheesyMatchLoad, CheesyMatchTime, CheesyMatchTiming, MATCH_TYPE_PLAYOFF,
  MATCH_TYPE_PRACTICE, MATCH_TYPE_QUALIFICATION, STATE_AUTO_PERIOD, STATE_PAUSE_PERIOD, STATE_POST_MATCH,
  STATE_POST_TIMEOUT, STATE_PRE_MATCH, STATE_TELEOP_PERIOD, STATE_TIMEOUT_ACTIVE, parse_cycle_time_sec,
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
  let (referee_cmd_tx, referee_cmd_rx) = mpsc::channel::<Message>(64);
  let (red_scoring_cmd_tx, red_scoring_cmd_rx) = mpsc::channel::<Message>(64);
  let (blue_scoring_cmd_tx, blue_scoring_cmd_rx) = mpsc::channel::<Message>(64);

  tokio::join!(
    run_field_monitor(config.clone(), match_info_tx, shutdown.subscribe()),
    run_field_status_monitor(config.clone(), match_info_rx.clone(), shutdown.subscribe()),
    run_referee_panel(config.clone(), referee_cmd_rx, shutdown.subscribe()),
    run_scoring_panel(config.clone(), "red", red_scoring_cmd_rx, shutdown.subscribe()),
    run_scoring_panel(config.clone(), "blue", blue_scoring_cmd_rx, shutdown.subscribe()),
    super::sync::run(match_info_rx, referee_cmd_tx, red_scoring_cmd_tx, blue_scoring_cmd_tx, shutdown.subscribe()),
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
  // The last match_id we've already reported as completed, so reaching PostMatch only
  // triggers a single completion signal per match rather than once per matchTime tick.
  completed_match_id: Option<i32>,
  // The match_id currently "armed" to fire a reset the next time it's seen back in
  // PreMatch - see `check_match_reset`.
  reset_pending_for: Option<i32>,
  // Cheesy Arena's last-known cycle time (gap between the previous two matches' starts),
  // used as an estimate for the current gap. See CheesyEventStatus.
  cycle_time_sec: Option<i64>,
  // Unix seconds at which we estimate the next match will start, captured once when the
  // current match reaches PostMatch and cleared once the next match actually starts.
  next_match_estimated_at: Option<i64>,
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

  fn merge_event_status(&mut self, s: CheesyEventStatus) {
    self.cycle_time_sec = parse_cycle_time_sec(&s.cycle_time);
  }

  // A match is considered "played" once it reaches PostMatch - unlike Cheesy's `scorePosted`
  // event (which the field_monitor websocket doesn't subscribe to), this is derived from
  // arenaStatus/matchTime, which we already receive on this connection. Also captures/clears
  // the next-match estimate: the deadline is set the instant a match reaches PostMatch (using
  // whatever cycle time is currently known), and cleared once the next match actually starts.
  fn check_match_completed(&mut self) -> Option<i32> {
    if self.match_state == STATE_AUTO_PERIOD {
      self.next_match_estimated_at = None;
    }

    if self.match_id != 0 && self.match_state == STATE_POST_MATCH && self.completed_match_id != Some(self.match_id) {
      self.completed_match_id = Some(self.match_id);
      if let Some(cycle_time_sec) = self.cycle_time_sec {
        let now =
          std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap_or_default().as_secs() as i64;
        self.next_match_estimated_at = Some(now + cycle_time_sec);
      }
      Some(self.match_id)
    } else {
      None
    }
  }

  // Aborting and redoing the same scheduled match doesn't get a new match_id in Cheesy Arena
  // (it's the same DB row, just replayed) - our own match_id-keyed state never resets on its
  // own for that case, which otherwise leaves stale fouls/cards/climb calls sitting around
  // for the redo. Cheesy's own `discardResults`/`ResetMatch` handler (bound to the
  // scorekeeper's "Discard Results" button) *does* reset its own bypass array for exactly
  // this reason (see field/arena.go) - mirror that by wiping our copy too, keyed off the
  // same PostMatch -> PreMatch transition. This is tracked here (armed on PostMatch, fired on
  // PreMatch) rather than downstream via the FmsMatchInfo watch channel, since a watch
  // channel only ever holds its latest value - if PostMatch and PreMatch are published in
  // quick succession (abort immediately followed by discard results), a downstream watcher
  // can miss the intermediate PostMatch value entirely and never notice the transition. This
  // accumulator processes every field message in order, so it can't miss it.
  fn check_match_reset(&mut self) -> Option<i32> {
    if self.match_id == 0 {
      return None;
    }

    if self.match_state == STATE_POST_MATCH {
      self.reset_pending_for = Some(self.match_id);
      None
    } else if self.match_state == STATE_PRE_MATCH && self.reset_pending_for == Some(self.match_id) {
      self.reset_pending_for = None;
      Some(self.match_id)
    } else {
      None
    }
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
      next_match_estimated_at_unix_sec: self.next_match_estimated_at.unwrap_or(0),
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

#[derive(Default)]
struct FieldMessageEffect {
  info_changed: bool,
  completed_match_id: Option<i32>,
  reset_match_id: Option<i32>,
}

fn info_changed() -> FieldMessageEffect {
  FieldMessageEffect { info_changed: true, completed_match_id: None, reset_match_id: None }
}

fn no_effect() -> FieldMessageEffect {
  FieldMessageEffect::default()
}

fn process_field_message(raw: &str, acc: &mut Accumulator) -> FieldMessageEffect {
  let Ok(v) = serde_json::from_str::<serde_json::Value>(raw) else { return no_effect() };
  let Some(msg_type) = v.get("type").and_then(|t| t.as_str()) else { return no_effect() };
  let Some(data) = v.get("data") else { return no_effect() };

  match msg_type {
    "arenaStatus" => match serde_json::from_value::<CheesyArenaStatus>(data.clone()) {
      Ok(s) => {
        acc.merge_arena_status(s);
        FieldMessageEffect {
          info_changed: true,
          completed_match_id: acc.check_match_completed(),
          reset_match_id: acc.check_match_reset(),
        }
      }
      Err(e) => {
        log::warn!("[FMS] Failed to parse arenaStatus: {e}");
        no_effect()
      }
    },
    "matchLoad" => match CheesyMatchLoad::from_value(data) {
      Some(s) => {
        acc.merge_match_load(s);
        info_changed()
      }
      None => no_effect(),
    },
    "matchTime" => match serde_json::from_value::<CheesyMatchTime>(data.clone()) {
      Ok(s) => {
        acc.merge_match_time(s);
        FieldMessageEffect {
          info_changed: true,
          completed_match_id: acc.check_match_completed(),
          reset_match_id: acc.check_match_reset(),
        }
      }
      Err(e) => {
        log::warn!("[FMS] Failed to parse matchTime: {e}");
        no_effect()
      }
    },
    "matchTiming" => match serde_json::from_value::<CheesyMatchTiming>(data.clone()) {
      Ok(s) => {
        acc.timing = s;
        no_effect()
      }
      Err(e) => {
        log::warn!("[FMS] Failed to parse matchTiming: {e}");
        no_effect()
      }
    },
    "eventStatus" => match serde_json::from_value::<CheesyEventStatus>(data.clone()) {
      Ok(s) => {
        acc.merge_event_status(s);
        no_effect()
      }
      Err(e) => {
        log::warn!("[FMS] Failed to parse eventStatus: {e}");
        no_effect()
      }
    },
    _ => no_effect(),
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
  let url =
    format!("ws://{}:{}/displays/field_monitor/websocket?displayId={}", config.host, config.port, config.display_id);
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
                  let effect = process_field_message(text.as_str(), &mut acc);
                  if effect.info_changed {
                    publish_match_info(acc.to_fms_match_info(), &match_info_tx).await;
                  }
                  if let Some(match_id) = effect.completed_match_id
                    && let Err(e) = MatchStateRecord::mark_match_completed(match_id).await
                  {
                    log::warn!("[FMS] Failed to mark match {match_id} completed: {e}");
                  }
                  if let Some(match_id) = effect.reset_match_id {
                    log::info!(
                      "[FMS] Match {match_id} returned to PreMatch after PostMatch with no id change - treating as a redo and resetting stored state"
                    );
                    if let Err(e) =
                      MatchStateRecord::update_match_state(match_id, MatchStateRecord { match_id, ..Default::default() }).await
                    {
                      log::warn!("[FMS] Failed to reset match state for redo of match {match_id}: {e}");
                    }
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

// --- Field status monitor (read-only, unauthenticated) ---
//
// Cheesy Arena's actual field volunteer/reset signal - the real source of truth for
// field_state, settable either via our own referee panel commands (see fms/cheesy/sync.rs) or
// directly from Cheesy's native scorekeeper interface - is only broadcast to the alliance
// station display and match play websockets (`allianceStationDisplayMode`), not to the field
// monitor one. This is a separate connection purely to observe it, so RefLink's field_state
// reflects Cheesy's actual state regardless of who changed it.
fn map_alliance_station_display_mode(mode: &str) -> FieldState {
  match mode {
    "signalCount" => FieldState::Count,
    "fieldReset" => FieldState::Reset,
    _ => FieldState::Match,
  }
}

fn parse_field_status_message(raw: &str) -> Option<FieldState> {
  let v: serde_json::Value = serde_json::from_str(raw).ok()?;
  if v.get("type").and_then(|t| t.as_str()) != Some("allianceStationDisplayMode") {
    return None;
  }
  Some(map_alliance_station_display_mode(v.get("data")?.as_str()?))
}

async fn run_field_status_monitor(
  config: CheesyConfig,
  mut match_info_rx: watch::Receiver<Option<FmsMatchInfo>>,
  mut shutdown_rx: broadcast::Receiver<()>,
) {
  let url = format!(
    "ws://{}:{}/displays/alliance_station/websocket?displayId={}-status",
    config.host, config.port, config.display_id
  );
  let mut delay = Duration::from_secs(1);

  loop {
    log::info!("[FMS] Connecting to field status monitor at {url}");
    let connect_result = tokio::select! {
      res = connect_async(&url) => res,
      _ = shutdown_rx.recv() => return,
    };

    match connect_result {
      Ok((mut ws, _)) => {
        log::info!("[FMS] Field status monitor connected");
        delay = Duration::from_secs(1);

        // Cheesy Arena actually does bootstrap this notifier's current value immediately on
        // connect (see websocket.HandleNotifiers), not just on the next change - but this
        // connection races independently against run_field_monitor, so that bootstrap message
        // can arrive before match_info_rx knows the current match_id yet, and would otherwise
        // be silently dropped. Cache the last value we've seen and (re)apply it once/whenever
        // match_info_rx has a match_id, rather than only reacting to actual state changes.
        let mut last_known_field_state: Option<FieldState> = None;

        loop {
          tokio::select! {
            msg = ws.next() => {
              match msg {
                Some(Ok(Message::Text(text))) => {
                  let Some(field_state) = parse_field_status_message(text.as_str()) else { continue };
                  last_known_field_state = Some(field_state);
                  let Some(match_id) = match_info_rx.borrow().as_ref().map(|i| i.match_id) else { continue };
                  // match_id 0 means no match is loaded (idle) - there's no record to attach
                  // field_state to, and Cheesy re-broadcasts this notifier continuously, so
                  // without this guard every idle tick would spam a create-on-miss DB write.
                  if match_id != 0 && let Err(e) = MatchStateRecord::update_field_state_from_fms(match_id, field_state).await {
                    log::warn!("[FMS] Failed to update field state: {e}");
                  }
                }
                Some(Ok(Message::Close(_))) | None => break,
                Some(Err(e)) => {
                  log::warn!("[FMS] Field status monitor error: {e}");
                  break;
                }
                _ => {}
              }
            }
            result = match_info_rx.changed() => {
              if result.is_err() {
                continue;
              }
              let Some(field_state) = last_known_field_state else { continue };
              let Some(match_id) = match_info_rx.borrow().as_ref().map(|i| i.match_id) else { continue };
              if match_id != 0 && let Err(e) = MatchStateRecord::update_field_state_from_fms(match_id, field_state).await {
                log::warn!("[FMS] Failed to update field state: {e}");
              }
            }
            _ = shutdown_rx.recv() => return,
          }
        }

        log::warn!("[FMS] Field status monitor disconnected");
      }
      Err(e) => log::debug!("[FMS] Field status monitor connect failed: {e}"),
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

async fn run_referee_panel(
  config: CheesyConfig,
  cmd_rx: mpsc::Receiver<Message>,
  shutdown_rx: broadcast::Receiver<()>,
) {
  run_authenticated_panel(
    config,
    "/panels/referee/websocket".to_string(),
    "referee panel".to_string(),
    cmd_rx,
    shutdown_rx,
  )
  .await;
}

// Cheesy Arena's scoring interface is alliance-scoped - a separate websocket per alliance,
// each only affecting that alliance's RealtimeScore (see web/scoring_panel.go). This is where
// auto/endgame tower (climb) calls get pushed, since - unlike fouls/cards - the referee panel
// websocket has no command for them.
async fn run_scoring_panel(
  config: CheesyConfig,
  alliance: &'static str,
  cmd_rx: mpsc::Receiver<Message>,
  shutdown_rx: broadcast::Receiver<()>,
) {
  run_authenticated_panel(
    config,
    format!("/panels/scoring/{alliance}/websocket"),
    format!("{alliance} scoring panel"),
    cmd_rx,
    shutdown_rx,
  )
  .await;
}

// --- Referee/scoring panels (bidirectional, admin-gated) ---
//
// Both are the same shape: log in for a session cookie, open a websocket at some admin-gated
// path, then just relay whatever `cmd_tx` sends until the connection drops, reconnecting with
// backoff. The `read` half is only there to detect the server closing/erroring the connection.

async fn run_authenticated_panel(
  config: CheesyConfig,
  path: String,
  label: String,
  mut cmd_rx: mpsc::Receiver<Message>,
  mut shutdown_rx: broadcast::Receiver<()>,
) {
  let url = format!("ws://{}:{}{}", config.host, config.port, path);
  let mut delay = Duration::from_secs(1);

  loop {
    let cookie = match login(&config).await {
      Ok(c) => c,
      Err(e) => {
        log::warn!("[FMS] {label} login failed: {e}");
        None
      }
    };

    let mut request = match url.as_str().into_client_request() {
      Ok(r) => r,
      Err(e) => {
        log::error!("[FMS] Invalid {label} URL: {e}");
        return;
      }
    };
    if let Some(cookie) = &cookie
      && let Ok(value) = cookie.parse()
    {
      request.headers_mut().insert(http::header::COOKIE, value);
    }

    log::info!("[FMS] Connecting to {label} at {url}");
    let connect_result = tokio::select! {
      res = connect_async(request) => res,
      _ = shutdown_rx.recv() => return,
    };

    match connect_result {
      Ok((ws, _)) => {
        log::info!("[FMS] {label} connected");
        delay = Duration::from_secs(1);
        let (mut write, mut read) = ws.split();

        loop {
          tokio::select! {
            cmd = cmd_rx.recv() => {
              match cmd {
                Some(msg) => {
                  if let Err(e) = write.send(msg).await {
                    log::warn!("[FMS] Failed to send {label} command: {e}");
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
                  log::warn!("[FMS] {label} error: {e}");
                  break;
                }
                _ => {}
              }
            }
            _ = shutdown_rx.recv() => return,
          }
        }

        log::warn!("[FMS] {label} disconnected");
      }
      Err(e) => log::debug!("[FMS] {label} connect failed: {e}"),
    }

    tokio::select! {
      _ = tokio::time::sleep(delay) => {}
      _ = shutdown_rx.recv() => return,
    }
    delay = (delay * 2).min(Duration::from_secs(10));
  }
}
