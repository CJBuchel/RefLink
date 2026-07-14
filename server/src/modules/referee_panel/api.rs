use std::pin::Pin;

use tokio_stream::{Stream, StreamExt};
use tonic::{Request, Response, Status};

use crate::{
  generated::{
    api::{RefereeStreamRequest, RefereeStreamResponse, referee_panel_service_server::RefereePanelService},
    common::{MatchPhase, PanelType},
    db::MatchStateRecord,
  },
  modules::arena::MatchStateRepository,
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

    // Spawn a task that consumes messages from the client.
    tokio::spawn(async move {
      while let Some(message) = incoming.next().await {
        match message {
          Ok(request) => {
            let panel_type = PanelType::try_from(request.panel).unwrap_or_default();
            log::info!("Panel {}", panel_type.as_str_name());
            // Update your server state here.
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
    });

    // Example outgoing stream
    let stream = async_stream::stream! {
      // ---------------------------------------------------------------------
      // Initial state (sent once immediately after the client connects)
      // ---------------------------------------------------------------------

      yield Ok(RefereeStreamResponse {
          match_id: 2,
          match_phase: MatchPhase::Auto as i32,
          alliance_station_1_team_number: "4788".to_string(),
          alliance_station_2_team_number: "5333".to_string(),
          alliance_station_3_team_number: "5663".to_string(),
          partner_panel: None,
      });

      // ---------------------------------------------------------------------
      // Subscribe to future updates
      // ---------------------------------------------------------------------

      // let mut rx = MATCH_STATE_EVENTS.subscribe();

      loop {
        // TODO:
        // Wait for the next update from repository/event bus.
        // Placeholder so the example compiles.
        tokio::time::sleep(std::time::Duration::from_secs(60)).await;
      }
    };

    Ok(Response::new(Box::pin(stream)))
  }
}
