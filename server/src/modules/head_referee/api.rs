use std::{pin::Pin, time::Duration};

use tokio_stream::{Stream, StreamExt};
use tonic::{Request, Response, Status};

use crate::{
  config::CONFIG,
  core::{
    events::{ChangeEvent, EVENT_BUS},
    shutdown::with_shutdown,
  },
  generated::{
    api::{
      CommitAndPostRequest, CommitAndPostResponse, HeadRefereeStreamRequest, HeadRefereeStreamResponse,
      MatchAllianceState, PanelPresence, ToggleBypassRequest, ToggleBypassResponse,
      head_referee_panel_service_server::HeadRefereePanelService,
    },
    common::TeamAllianceStationType,
    db::MatchStateRecord,
    fms::FmsMatchInfo,
  },
  modules::{
    arena::{MatchStateRepository, map_teams},
    fms::{
      FmsStateRepository,
      cheesy::{BypassToggleRequest, CommitAndPostSignal},
    },
    referee_panel::presence,
  },
};

// The event bus now guarantees delivery of every published event to every subscriber (see
// core::events::EventBus), so this is no longer compensating for dropped/lagged events - it's a
// second line of defense against staleness from causes other than the bus itself (e.g. a bug
// in one of the event-driven branches below, or a state change this stream doesn't subscribe
// to at all).
const RECONCILE_INTERVAL: Duration = Duration::from_secs(2);

pub struct HeadRefereeApi;

// Re-derives stream state straight from source of truth (DB/Redis + in-memory presence), the
// same functions used at stream-start - used for the periodic reconciliation tick.
async fn reconcile(match_rotations: u16) -> (FmsMatchInfo, Option<MatchStateRecord>, i32, PanelPresence) {
  let fms_info = FmsMatchInfo::get_current().await.ok().flatten().unwrap_or_default();
  let match_state = MatchStateRecord::get_match_state(fms_info.match_id).await.ok();
  let rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(0);
  let panel_presence = presence::snapshot();
  (fms_info, match_state, rotation, panel_presence)
}

#[tonic::async_trait]
impl HeadRefereePanelService for HeadRefereeApi {
  type HeadRefereeStreamStream = Pin<Box<dyn Stream<Item = Result<HeadRefereeStreamResponse, Status>> + Send>>;

  async fn head_referee_stream(
    &self,
    request: Request<tonic::Streaming<HeadRefereeStreamRequest>>,
  ) -> Result<Response<Self::HeadRefereeStreamStream>, Status> {
    let mut incoming = request.into_inner();

    // Spawn a task that consumes messages from the client and writes head referee state to Redis.
    tokio::spawn(async move {
      while let Some(message) = incoming.next().await {
        match message {
          Ok(request) => {
            if let Some(state) = request.state {
              match MatchStateRecord::update_head_referee_state(request.match_id, state).await {
                Ok(_) => {}
                Err(e) => log::warn!("Failed to update head referee state: {e}"),
              }
            }
          }

          Err(status) => {
            log::warn!("Disconnected: {status}");
            break;
          }
        }
      }
    });

    let bus = EVENT_BUS.get().ok_or_else(|| Status::internal("Event bus not initialized"))?;
    let mut fms_rx = bus.subscribe::<FmsMatchInfo>().map_err(|e| Status::internal(e.to_string()))?;
    let mut match_state_rx = bus.subscribe::<MatchStateRecord>().map_err(|e| Status::internal(e.to_string()))?;
    let mut presence_rx = bus.subscribe::<PanelPresence>().map_err(|e| Status::internal(e.to_string()))?;

    let match_rotations = CONFIG.get().map(|c| c.match_rotations).unwrap_or_default();
    let mut fms_info = FmsMatchInfo::get_current().await.ok().flatten().unwrap_or_default();
    let mut match_state = MatchStateRecord::get_match_state(fms_info.match_id).await.ok();
    let mut rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(0);
    let mut panel_presence = presence::snapshot();

    let stream = async_stream::stream! {
      let mut last = Some(build_response(&fms_info, match_state.as_ref(), rotation, panel_presence));
      yield Ok(last.clone().unwrap());

      // Fires every RECONCILE_INTERVAL regardless of whether any event arrived, so a client is
      // never stuck on stale state for longer than that - independent of missed/lagged/dropped
      // broadcast events, which pure push delivery can never fully rule out. Always yields
      // (even when nothing changed) so this doubles as a heartbeat - the client uses a gap in
      // receiving *anything* to detect a silently-wedged stream and force a reconnect, which
      // only works if silence during genuinely idle periods is impossible to confuse with that.
      let mut reconcile_tick = tokio::time::interval(RECONCILE_INTERVAL);
      reconcile_tick.tick().await; // first tick fires immediately - already covered by the yield above

      loop {
        tokio::select! {
          _ = reconcile_tick.tick() => {
            (fms_info, match_state, rotation, panel_presence) = reconcile(match_rotations).await;
            let candidate = build_response(&fms_info, match_state.as_ref(), rotation, panel_presence);
            last = Some(candidate.clone());
            yield Ok(candidate);
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
                let candidate = build_response(&fms_info, match_state.as_ref(), rotation, panel_presence);
                if last.as_ref() != Some(&candidate) {
                  last = Some(candidate.clone());
                  yield Ok(candidate);
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
                let candidate = build_response(&fms_info, match_state.as_ref(), rotation, panel_presence);
                if last.as_ref() != Some(&candidate) {
                  last = Some(candidate.clone());
                  yield Ok(candidate);
                }
              }
              Some(_) => {}
              None => break,
            }
          }
          event = presence_rx.recv() => {
            match event {
              Some(ChangeEvent::Message { data, .. }) => {
                panel_presence = data;
                let candidate = build_response(&fms_info, match_state.as_ref(), rotation, panel_presence);
                if last.as_ref() != Some(&candidate) {
                  last = Some(candidate.clone());
                  yield Ok(candidate);
                }
              }
              Some(_) => {}
              None => break,
            }
          }
        }
      }
    };

    Ok(Response::new(Box::pin(with_shutdown(stream))))
  }

  // Deliberately not persisted anywhere (not in Redis, not tracked in memory) - see
  // BypassToggleRequest. Cheesy Arena owns whether a station is actually bypassed; we just
  // relay the ask.
  async fn toggle_bypass(
    &self,
    request: Request<ToggleBypassRequest>,
  ) -> Result<Response<ToggleBypassResponse>, Status> {
    let station = TeamAllianceStationType::try_from(request.into_inner().station)
      .map_err(|_| Status::invalid_argument("Unknown alliance station"))?;

    let bus = EVENT_BUS.get().ok_or_else(|| Status::internal("Event bus not initialized"))?;
    let _ =
      bus.publish(ChangeEvent::Message { topic: "toggle_bypass".to_string(), data: BypassToggleRequest { station } });

    Ok(Response::new(ToggleBypassResponse {}))
  }

  // Deliberately not persisted anywhere - see CommitAndPostSignal. Cheesy Arena itself
  // ignores this unless the match is actually in PostMatch, so there's nothing to check here.
  async fn commit_and_post(
    &self,
    _request: Request<CommitAndPostRequest>,
  ) -> Result<Response<CommitAndPostResponse>, Status> {
    let bus = EVENT_BUS.get().ok_or_else(|| Status::internal("Event bus not initialized"))?;
    let _ = bus.publish(ChangeEvent::Message { topic: "commit_and_post".to_string(), data: CommitAndPostSignal });

    Ok(Response::new(CommitAndPostResponse {}))
  }
}

fn build_response(
  fms_info: &FmsMatchInfo,
  match_state: Option<&MatchStateRecord>,
  rotate_in: i32,
  panel_presence: PanelPresence,
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
    panel_presence: Some(panel_presence),
  }
}
