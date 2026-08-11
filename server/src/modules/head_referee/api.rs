use tonic::{Request, Response, Status};

use crate::{
  core::events::{ChangeEvent, EVENT_BUS},
  generated::{
    api::{
      CommitAndPostRequest, CommitAndPostResponse, ToggleBypassRequest, ToggleBypassResponse,
      head_referee_panel_service_server::HeadRefereePanelService,
    },
    common::TeamAllianceStationType,
  },
  modules::fms::cheesy::{BypassToggleRequest, CommitAndPostSignal},
};

pub struct HeadRefereeApi;

// Match/rotation/presence state moved to MQTT (see modules::sync) - the only RPCs left here are
// genuinely request/response-shaped fire-once relays to Cheesy Arena.
#[tonic::async_trait]
impl HeadRefereePanelService for HeadRefereeApi {
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
