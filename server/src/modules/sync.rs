use std::time::Duration;

use prost::Message as _;

use crate::{
  config::CONFIG,
  core::{
    events::{ChangeEvent, EVENT_BUS},
    mqtt::{self, MqttInbound},
  },
  generated::{
    api::{HeadRefereeStreamRequest, HeadRefereeStreamResponse, MatchAllianceState, RefereeStreamRequest},
    common::{PanelType, TeamAllianceStationType},
    db::MatchStateRecord,
    fms::FmsMatchInfo,
  },
  modules::{
    arena::{MatchStateRepository, map_teams},
    fms::FmsStateRepository,
  },
};

pub const TOPIC_MATCH_STATE: &str = "reflink/match/state";
pub const TOPIC_HEAD_REFEREE_SUBMIT: &str = "reflink/head-referee/submit";
pub const TOPIC_REFEREE_SUBMIT_WILDCARD: &str = "reflink/referee-panel/+/submit";
const RECONCILE_INTERVAL: Duration = Duration::from_secs(2);

fn panel_slug(panel: PanelType) -> Option<&'static str> {
  match panel {
    PanelType::RedNear => Some("red-near"),
    PanelType::RedFar => Some("red-far"),
    PanelType::BlueNear => Some("blue-near"),
    PanelType::BlueFar => Some("blue-far"),
    _ => None,
  }
}

fn panel_from_slug(slug: &str) -> Option<PanelType> {
  match slug {
    "red-near" => Some(PanelType::RedNear),
    "red-far" => Some(PanelType::RedFar),
    "blue-near" => Some(PanelType::BlueNear),
    "blue-far" => Some(PanelType::BlueFar),
    _ => None,
  }
}

/// Topic a referee panel publishes its own submitted state to - also its MQTT presence topic's
/// prefix (`{submit_topic}/../presence`, published client-side, not something the server needs
/// to know about at all now that presence is broker-native via retained messages + LWT).
pub fn submit_topic(panel: PanelType) -> Option<String> {
  panel_slug(panel).map(|slug| format!("reflink/referee-panel/{slug}/submit"))
}

fn panel_from_submit_topic(topic: &str) -> Option<PanelType> {
  let slug = topic.strip_prefix("reflink/referee-panel/")?.strip_suffix("/submit")?;
  panel_from_slug(slug)
}

async fn reconcile(match_rotations: u16) -> (FmsMatchInfo, Option<MatchStateRecord>, i32) {
  let fms_info = FmsMatchInfo::get_current().await.ok().flatten().unwrap_or_default();
  let match_state = MatchStateRecord::get_match_state(fms_info.match_id).await.ok();
  let rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(0);
  (fms_info, match_state, rotation)
}

fn build_response(
  fms_info: &FmsMatchInfo,
  match_state: Option<&MatchStateRecord>,
  rotate_in: i32,
) -> HeadRefereeStreamResponse {
  let teams = map_teams(fms_info);

  HeadRefereeStreamResponse {
    match_id: fms_info.match_id,
    match_phase: fms_info.match_phase,
    red_alliance_state: Some(MatchAllianceState {
      alliance_team_1_state: teams.get(&(TeamAllianceStationType::Red1 as i32)).cloned(),
      alliance_team_2_state: teams.get(&(TeamAllianceStationType::Red2 as i32)).cloned(),
      alliance_team_3_state: teams.get(&(TeamAllianceStationType::Red3 as i32)).cloned(),
    }),
    blue_alliance_state: Some(MatchAllianceState {
      alliance_team_1_state: teams.get(&(TeamAllianceStationType::Blue1 as i32)).cloned(),
      alliance_team_2_state: teams.get(&(TeamAllianceStationType::Blue2 as i32)).cloned(),
      alliance_team_3_state: teams.get(&(TeamAllianceStationType::Blue3 as i32)).cloned(),
    }),
    rn: match_state.and_then(|r| r.rn),
    rf: match_state.and_then(|r| r.rf),
    bn: match_state.and_then(|r| r.bn),
    bf: match_state.and_then(|r| r.bf),
    hr: match_state.and_then(|r| r.hr),
    rotate_in,
  }
}

async fn publish_match_state(response: &HeadRefereeStreamResponse) {
  if let Err(e) = mqtt::publish(TOPIC_MATCH_STATE, true, response).await {
    log::warn!("[sync] Failed to publish match state: {e}");
  }
}

async fn handle_submit(inbound: MqttInbound) {
  if let Some(panel) = panel_from_submit_topic(&inbound.topic) {
    match RefereeStreamRequest::decode(inbound.payload.as_slice()) {
      Ok(request) => {
        if let Some(state) = request.state
          && let Err(e) = MatchStateRecord::update_panel_state(request.match_id, panel, state).await
        {
          log::warn!("[sync] Failed to update panel state: {e}");
        }
      }
      Err(e) => log::warn!("[sync] Failed to decode referee panel submit: {e}"),
    }
  } else if inbound.topic == TOPIC_HEAD_REFEREE_SUBMIT {
    match HeadRefereeStreamRequest::decode(inbound.payload.as_slice()) {
      Ok(request) => {
        if let Some(state) = request.state
          && let Err(e) = MatchStateRecord::update_head_referee_state(request.match_id, state).await
        {
          log::warn!("[sync] Failed to update head referee state: {e}");
        }
      }
      Err(e) => log::warn!("[sync] Failed to decode head referee submit: {e}"),
    }
  }
}

/// Replaces the old per-connection gRPC stream handlers (referee_panel/api.rs's and
/// head_referee/api.rs's `async_stream::stream!` blocks) with one long-running task: ingests
/// submitted panel/HR state from MQTT and republishes the aggregated match state (retained)
/// whenever it changes, instead of a separate task per connected client each computing its own
/// tailored view.
pub async fn run() {
  let match_rotations = CONFIG.get().map(|c| c.match_rotations).unwrap_or_default();

  let Some(bus) = EVENT_BUS.get() else {
    log::error!("[sync] Event bus not initialized");
    return;
  };

  let mut fms_rx = match bus.subscribe::<FmsMatchInfo>() {
    Ok(rx) => rx,
    Err(e) => {
      log::error!("[sync] Failed to subscribe to FMS events: {e}");
      return;
    }
  };
  let mut match_state_rx = match bus.subscribe::<MatchStateRecord>() {
    Ok(rx) => rx,
    Err(e) => {
      log::error!("[sync] Failed to subscribe to match state events: {e}");
      return;
    }
  };
  let mut mqtt_rx = match bus.subscribe::<MqttInbound>() {
    Ok(rx) => rx,
    Err(e) => {
      log::error!("[sync] Failed to subscribe to MQTT inbound events: {e}");
      return;
    }
  };

  let mut fms_info = FmsMatchInfo::get_current().await.ok().flatten().unwrap_or_default();
  let mut match_state = MatchStateRecord::get_match_state(fms_info.match_id).await.ok();
  let mut rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(0);

  let mut last = build_response(&fms_info, match_state.as_ref(), rotation);
  publish_match_state(&last).await;

  let mut tick = tokio::time::interval(RECONCILE_INTERVAL);
  tick.tick().await; // fires immediately - the publish above already covers t=0

  loop {
    tokio::select! {
      _ = tick.tick() => {
        (fms_info, match_state, rotation) = reconcile(match_rotations).await;
        let candidate = build_response(&fms_info, match_state.as_ref(), rotation);
        if candidate != last {
          last = candidate;
          publish_match_state(&last).await;
        }
      }
      event = fms_rx.recv() => {
        match event {
          Some(ChangeEvent::Message { data, .. }) => {
            let match_changed = data.match_id != fms_info.match_id;
            fms_info = data;
            if match_changed {
              match_state = MatchStateRecord::get_match_state(fms_info.match_id).await.ok();
              rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(rotation);
            }
            let candidate = build_response(&fms_info, match_state.as_ref(), rotation);
            if candidate != last {
              last = candidate;
              publish_match_state(&last).await;
            }
          }
          Some(_) => {}
          None => break,
        }
      }
      event = match_state_rx.recv() => {
        match event {
          Some(ChangeEvent::Record { id, data: Some(record), .. }) if id == fms_info.match_id.to_string() => {
            match_state = Some(record);
            rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(rotation);
            let candidate = build_response(&fms_info, match_state.as_ref(), rotation);
            if candidate != last {
              last = candidate;
              publish_match_state(&last).await;
            }
          }
          Some(_) => {}
          None => break,
        }
      }
      event = mqtt_rx.recv() => {
        match event {
          Some(ChangeEvent::Message { data, .. }) => handle_submit(data).await,
          Some(_) => {}
          None => break,
        }
      }
    }
  }
}
