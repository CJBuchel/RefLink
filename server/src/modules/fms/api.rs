use std::pin::Pin;

use tokio::sync::broadcast;
use tokio_stream::Stream;
use tonic::{Request, Response, Status};

use crate::{
  core::{
    events::{ChangeEvent, EVENT_BUS},
    shutdown::with_shutdown,
  },
  generated::fms::{
    FmsConnectionStatus, FmsMatchInfo, GetMatchInfoRequest, StreamConnectionStatusRequest, StreamMatchInfoRequest,
    fms_service_server::FmsService,
  },
  modules::fms::repository::FmsStateRepository,
};

pub struct FmsApi;

#[tonic::async_trait]
impl FmsService for FmsApi {
  type StreamMatchInfoStream = Pin<Box<dyn Stream<Item = Result<FmsMatchInfo, Status>> + Send>>;
  type StreamConnectionStatusStream = Pin<Box<dyn Stream<Item = Result<FmsConnectionStatus, Status>> + Send>>;

  async fn get_match_info(&self, _request: Request<GetMatchInfoRequest>) -> Result<Response<FmsMatchInfo>, Status> {
    match FmsMatchInfo::get_current().await {
      Ok(Some(info)) => Ok(Response::new(info)),
      Ok(None) => Ok(Response::new(FmsMatchInfo::default())),
      Err(e) => Err(Status::internal(e.to_string())),
    }
  }

  async fn stream_match_info(
    &self,
    _request: Request<StreamMatchInfoRequest>,
  ) -> Result<Response<Self::StreamMatchInfoStream>, Status> {
    let initial = FmsMatchInfo::get_current().await.ok().flatten();
    let bus = EVENT_BUS.get().ok_or_else(|| Status::internal("Event bus not initialized"))?;
    let mut rx = bus.subscribe::<FmsMatchInfo>().map_err(|e| Status::internal(e.to_string()))?;

    let stream = async_stream::stream! {
      if let Some(info) = initial {
        yield Ok(info);
      }

      loop {
        match rx.recv().await {
          Ok(ChangeEvent::Message { data, .. }) => yield Ok(data),
          Ok(_) => continue,
          Err(broadcast::error::RecvError::Lagged(n)) => {
            log::warn!("StreamMatchInfo lagged behind by {n} events");
            continue;
          }
          Err(broadcast::error::RecvError::Closed) => break,
        }
      }
    };

    Ok(Response::new(Box::pin(with_shutdown(stream))))
  }

  async fn stream_connection_status(
    &self,
    _request: Request<StreamConnectionStatusRequest>,
  ) -> Result<Response<Self::StreamConnectionStatusStream>, Status> {
    let bus = EVENT_BUS.get().ok_or_else(|| Status::internal("Event bus not initialized"))?;
    let mut rx = bus.subscribe::<FmsConnectionStatus>().map_err(|e| Status::internal(e.to_string()))?;

    let stream = async_stream::stream! {
      loop {
        match rx.recv().await {
          Ok(ChangeEvent::Message { data, .. }) => yield Ok(data),
          Ok(_) => continue,
          Err(broadcast::error::RecvError::Lagged(n)) => {
            log::warn!("StreamConnectionStatus lagged behind by {n} events");
            continue;
          }
          Err(broadcast::error::RecvError::Closed) => break,
        }
      }
    };

    Ok(Response::new(Box::pin(with_shutdown(stream))))
  }
}
