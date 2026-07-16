use std::{net::SocketAddr, time::Duration};

use anyhow::Result;
use tonic::transport::Server;
use tonic_web::GrpcWebLayer;
use tower_http::cors::{Any, CorsLayer};

use crate::{
  core::shutdown::ShutdownNotifier,
  generated::{
    api::{
      head_referee_panel_service_server::HeadRefereePanelServiceServer, health_service_server::HealthServiceServer,
      referee_panel_service_server::RefereePanelServiceServer,
    },
    fms::fms_service_server::FmsServiceServer,
  },
  modules::{fms::FmsApi, head_referee::HeadRefereeApi, health::HealthApi, referee_panel::RefereePanelApi},
};

pub struct Api {
  addr: SocketAddr,
}

impl Api {
  pub fn new(addr: SocketAddr) -> Self {
    Self { addr }
  }

  pub async fn serve(&self) -> Result<()> {
    let mut shutdown_rx = ShutdownNotifier::get().subscribe();

    let cors = CorsLayer::new().allow_origin(Any).allow_headers(Any).allow_methods(Any).expose_headers(Any);

    log::info!("Starting API Server...");

    let router = Server::builder()
      // Enable HTTP/1.1 for gRPC-Web (browsers)
      .accept_http1(true)
      // TCP Keep alive (detect broken connections at OS level)
      .tcp_keepalive(Some(Duration::from_secs(60)))
      // HTTP/2 keep alive (detect unresponsive clients)
      .http2_keepalive_interval(Some(Duration::from_secs(30)))
      .http2_keepalive_timeout(Some(Duration::from_secs(10)))
      // Max concurrent streams per connection
      .initial_stream_window_size(Some(1024 * 1024)) // 1MB
      .initial_connection_window_size(Some(1024 * 1024 * 2)) // 2MB
      // Add CORS layer for web clients
      .layer(cors)
      // Add gRPC-Web layer support
      .layer(GrpcWebLayer::new())
      // Add services
      .add_service(HealthServiceServer::new(HealthApi {}))
      .add_service(RefereePanelServiceServer::new(RefereePanelApi {}))
      .add_service(HeadRefereePanelServiceServer::new(HeadRefereeApi {}))
      .add_service(FmsServiceServer::new(FmsApi {}));
    match router
      .serve_with_shutdown(self.addr, async move {
        shutdown_rx.recv().await.ok();
      })
      .await
    {
      Ok(()) => Ok(()),
      Err(e) => {
        log::error!("Error: {:?}", e);
        Err(anyhow::Error::msg("Failed to serve API"))
      }
    }
  }
}
