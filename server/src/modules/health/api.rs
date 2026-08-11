use std::pin::Pin;

use tokio_stream::{Stream, StreamExt};
use tonic::{Request, Response, Status};

use crate::{
  core::{
    events::{HEARTBEAT_INTERVAL, with_heartbeat},
    shutdown::with_shutdown,
  },
  generated::api::{GetHealthRequest, GetHealthResponse, health_service_server::HealthService},
};

pub struct HealthApi;

#[tonic::async_trait]
impl HealthService for HealthApi {
  type StreamHealthStream = Pin<Box<dyn Stream<Item = Result<GetHealthResponse, Status>> + Send>>;

  async fn get_health(&self, _: Request<GetHealthRequest>) -> Result<Response<GetHealthResponse>, Status> {
    Ok(Response::new(GetHealthResponse {}))
  }

  async fn stream_health(&self, _: Request<GetHealthRequest>) -> Result<Response<Self::StreamHealthStream>, Status> {
    // No events of its own (there's nothing to subscribe to - liveness is the only thing this
    // reports), so it's an always-empty source with everything coming from the heartbeat tick's
    // resync. Goes through the same `with_heartbeat` as every other route regardless, so this
    // stays consistent if it ever needs real content later, and a client watchdog timeout can
    // be defined off the one shared `HEARTBEAT_INTERVAL` for every route including this one.
    let events = tokio_stream::empty();
    let stream = with_heartbeat(events, HEARTBEAT_INTERVAL, || async { GetHealthResponse {} }).map(Ok);

    let stream = with_shutdown(stream);
    Ok(Response::new(Box::pin(stream)))
  }
}
