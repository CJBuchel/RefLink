use tonic::{Request, Response, Status};

use crate::{
  generated::fms::{FmsMatchInfo, GetMatchInfoRequest, fms_service_server::FmsService},
  modules::fms::FmsStateRepository,
};

pub struct FmsApi;

// FmsMatchInfo/FmsConnectionStatus streaming moved to MQTT (reflink/fms/match-info,
// reflink/fms/connection-status - see fms::cheesy::client::publish_match_info/
// publish_connection_status). GetMatchInfo stays as a plain unary one-shot fetch.
#[tonic::async_trait]
impl FmsService for FmsApi {
  async fn get_match_info(&self, _request: Request<GetMatchInfoRequest>) -> Result<Response<FmsMatchInfo>, Status> {
    match FmsMatchInfo::get_current().await {
      Ok(Some(info)) => Ok(Response::new(info)),
      Ok(None) => Ok(Response::new(FmsMatchInfo::default())),
      Err(e) => Err(Status::internal(e.to_string())),
    }
  }
}
