use anyhow::Result;

use crate::{
  config::ServerConfig,
  core::{api::Api, events::init_event_bus, scheduler::SchedulerPool},
  db::init_db,
  modules::fms,
};

pub struct Server {
  config: ServerConfig,
  scheduler: SchedulerPool,
}

impl Server {
  pub fn new(config: Option<ServerConfig>) -> Self {
    let config = match config {
      Some(cfg) => cfg,
      None => ServerConfig::parse_from_cli(),
    };

    Self { config, scheduler: SchedulerPool::new() }
  }

  pub async fn run(mut self) -> Result<()> {
    log::info!("Running server with config: {:?}", self.config);

    // let shutdown_notifier = ShutdownNotifier::get();

    // Init event bus
    if let Err(e) = init_event_bus(1024) {
      log::error!("Failed to initialize event bus: {}", e);
      return Err(e);
    }

    // Init DB
    if let Err(e) = init_db(None).await {
      log::error!("Failed to initialize database: {}", e);
      return Err(e);
    }

    pub async fn api_service(config: ServerConfig) {
      let api_socket_addr = format!("{}:{}", config.addr, config.api_port).parse().expect("Error parsing API address");
      let api_server = Api::new(api_socket_addr);
      if let Err(e) = api_server.serve().await {
        log::error!("API Server Error: {:?}", e);
      }
    }

    // Spawn API Server
    self.scheduler.spawn(api_service(self.config.clone()));

    // Spawn FMS connector (Cheesy Arena)
    if self.config.fms_enabled {
      self.scheduler.spawn(fms::run(self.config.clone()));
    } else {
      log::info!("FMS connector disabled (fms_enabled=false)");
    }

    // Await all services
    self.scheduler.wait_all().await?;

    Ok(())
  }
}
