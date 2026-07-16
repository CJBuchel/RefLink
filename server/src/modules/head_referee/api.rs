use std::pin::Pin;

use tokio::sync::broadcast;
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
      HeadRefereeStreamRequest, HeadRefereeStreamResponse, MatchAllianceState, PanelPresence,
      head_referee_panel_service_server::HeadRefereePanelService,
    },
    common::TeamAllianceStationType,
    db::MatchStateRecord,
    fms::FmsMatchInfo,
  },
  modules::{
    arena::{MatchStateRepository, map_teams},
    fms::FmsStateRepository,
    referee_panel::presence,
  },
};

pub struct HeadRefereeApi;

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
    let mut rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or((false, 0));
    let mut panel_presence = presence::snapshot();

    let stream = async_stream::stream! {
      yield Ok(build_response(&fms_info, match_state.as_ref(), rotation, panel_presence));

      loop {
        tokio::select! {
          event = fms_rx.recv() => {
            match event {
              Ok(ChangeEvent::Message { data, .. }) => {
                let match_changed = data.match_id != fms_info.match_id;
                fms_info = data;
                if match_changed {
                  match_state = MatchStateRecord::get_match_state(fms_info.match_id).await.ok();
                  rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(rotation);
                }
                yield Ok(build_response(&fms_info, match_state.as_ref(), rotation, panel_presence));
              }
              Ok(_) => {}
              Err(broadcast::error::RecvError::Lagged(n)) => {
                log::warn!("HeadRefereeStream lagged behind FMS events by {n}");
              }
              Err(broadcast::error::RecvError::Closed) => break,
            }
          }
          event = match_state_rx.recv() => {
            match event {
              Ok(ChangeEvent::Record { id, data: Some(record), .. }) if id == fms_info.match_id.to_string() => {
                match_state = Some(record);
                yield Ok(build_response(&fms_info, match_state.as_ref(), rotation, panel_presence));
              }
              Ok(_) => {}
              Err(broadcast::error::RecvError::Lagged(n)) => {
                log::warn!("HeadRefereeStream lagged behind match state events by {n}");
              }
              Err(broadcast::error::RecvError::Closed) => break,
            }
          }
          event = presence_rx.recv() => {
            match event {
              Ok(ChangeEvent::Message { data, .. }) => {
                panel_presence = data;
                yield Ok(build_response(&fms_info, match_state.as_ref(), rotation, panel_presence));
              }
              Ok(_) => {}
              Err(broadcast::error::RecvError::Lagged(n)) => {
                log::warn!("HeadRefereeStream lagged behind presence events by {n}");
              }
              Err(broadcast::error::RecvError::Closed) => break,
            }
          }
        }
      }
    };

    Ok(Response::new(Box::pin(with_shutdown(stream))))
  }
}

fn build_response(
  fms_info: &FmsMatchInfo,
  match_state: Option<&MatchStateRecord>,
  rotation: (bool, i32),
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
    rotate: rotation.0,
    rotate_in: rotation.1,
    panel_presence: Some(panel_presence),
  }
}
