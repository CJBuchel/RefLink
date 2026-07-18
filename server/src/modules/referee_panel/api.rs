use std::pin::Pin;

use tokio::sync::{broadcast, watch};
use tokio_stream::{Stream, StreamExt};
use tonic::{Request, Response, Status};

use crate::{
  config::CONFIG,
  core::{
    events::{ChangeEvent, EVENT_BUS},
    shutdown::with_shutdown,
  },
  generated::{
    api::{MatchAllianceState, RefereeStreamRequest, RefereeStreamResponse, referee_panel_service_server::RefereePanelService},
    common::{PanelType, RefereePanelState, TeamAllianceStationType},
    db::MatchStateRecord,
    fms::FmsMatchInfo,
  },
  modules::{
    arena::{MatchStateRepository, map_teams},
    fms::FmsStateRepository,
    referee_panel::presence,
  },
};

pub struct RefereePanelApi;

#[tonic::async_trait]
impl RefereePanelService for RefereePanelApi {
  type RefereeStreamStream = Pin<Box<dyn Stream<Item = Result<RefereeStreamResponse, Status>> + Send>>;

  async fn referee_stream(
    &self,
    request: Request<tonic::Streaming<RefereeStreamRequest>>,
  ) -> Result<Response<Self::RefereeStreamStream>, Status> {
    let mut incoming = request.into_inner();
    let (panel_type_tx, mut panel_type_rx) = watch::channel::<Option<PanelType>>(None);

    // Spawn a task that consumes messages from the client and writes panel state to Redis.
    // The panel's own `match_id` is authoritative for *where* its state gets written; the
    // `match_id` reported back to every client (below) instead follows whatever match the
    // FMS currently has loaded.
    tokio::spawn(async move {
      let mut connected_panel: Option<PanelType> = None;

      while let Some(message) = incoming.next().await {
        match message {
          Ok(request) => {
            let panel_type = PanelType::try_from(request.panel).unwrap_or_default();
            let _ = panel_type_tx.send(Some(panel_type));

            if connected_panel != Some(panel_type) {
              if let Some(previous) = connected_panel {
                presence::mark_disconnected(previous);
              }
              presence::mark_connected(panel_type);
              connected_panel = Some(panel_type);
            }

            if let Some(state) = request.state {
              match MatchStateRecord::update_panel_state(request.match_id, panel_type, state).await {
                Ok(_) => {}
                Err(e) => log::warn!("Failed to update panel state: {e}"),
              }
            }
          }

          Err(status) => {
            log::warn!("Disconnected: {status}");
            break;
          }
        }
      }

      if let Some(panel_type) = connected_panel {
        presence::mark_disconnected(panel_type);
      }
    });

    let bus = EVENT_BUS.get().ok_or_else(|| Status::internal("Event bus not initialized"))?;
    let mut fms_rx = bus.subscribe::<FmsMatchInfo>().map_err(|e| Status::internal(e.to_string()))?;
    let mut match_state_rx = bus.subscribe::<MatchStateRecord>().map_err(|e| Status::internal(e.to_string()))?;

    let match_rotations = CONFIG.get().map(|c| c.match_rotations).unwrap_or_default();
    let mut fms_info = FmsMatchInfo::get_current().await.ok().flatten().unwrap_or_default();
    let mut match_state = MatchStateRecord::get_match_state(fms_info.match_id).await.ok();
    let mut rotation = MatchStateRecord::compute_rotation(match_rotations).await.unwrap_or(0);
    let mut panel_type: Option<PanelType> = None;

    let stream = async_stream::stream! {
      yield Ok(build_response(&fms_info, match_state.as_ref(), panel_type, rotation));

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
                yield Ok(build_response(&fms_info, match_state.as_ref(), panel_type, rotation));
              }
              Ok(_) => {}
              Err(broadcast::error::RecvError::Lagged(n)) => {
                log::warn!("RefereeStream lagged behind FMS events by {n}");
              }
              Err(broadcast::error::RecvError::Closed) => break,
            }
          }
          event = match_state_rx.recv() => {
            match event {
              Ok(ChangeEvent::Record { id, data: Some(record), .. }) if id == fms_info.match_id.to_string() => {
                match_state = Some(record);
                yield Ok(build_response(&fms_info, match_state.as_ref(), panel_type, rotation));
              }
              Ok(_) => {}
              Err(broadcast::error::RecvError::Lagged(n)) => {
                log::warn!("RefereeStream lagged behind match state events by {n}");
              }
              Err(broadcast::error::RecvError::Closed) => break,
            }
          }
          _ = panel_type_rx.changed() => {
            panel_type = *panel_type_rx.borrow();
            yield Ok(build_response(&fms_info, match_state.as_ref(), panel_type, rotation));
          }
        }
      }
    };

    Ok(Response::new(Box::pin(with_shutdown(stream))))
  }
}

// Near/far panels pair up across the field and see each other's calls; the head referee
// (and any not-yet-identified panel) doesn't have a single partner - it'll see every panel
// at once once that UI exists.
fn partner_panel_state(match_state: Option<&MatchStateRecord>, panel_type: Option<PanelType>) -> Option<RefereePanelState> {
  let record = match_state?;
  match panel_type? {
    PanelType::RedNear => record.rf,
    PanelType::RedFar => record.rn,
    PanelType::BlueNear => record.bf,
    PanelType::BlueFar => record.bn,
    _ => None,
  }
}

fn build_response(
  fms_info: &FmsMatchInfo,
  match_state: Option<&MatchStateRecord>,
  panel_type: Option<PanelType>,
  rotate_in: i32,
) -> RefereeStreamResponse {
  let teams = map_teams(fms_info);
  let ref_review_required = match_state.and_then(|r| r.hr.as_ref()).map(|hr| hr.ref_review_required).unwrap_or(false);

  RefereeStreamResponse {
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
    partner_panel: partner_panel_state(match_state, panel_type),
    rotate_in,
    ref_review_required,
  }
}
