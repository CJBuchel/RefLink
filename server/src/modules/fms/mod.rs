mod api;
pub mod cheesy;
mod repository;

pub use api::*;
pub use repository::*;

use crate::config::ServerConfig;

pub async fn run(config: ServerConfig) {
  let cheesy_config = cheesy::CheesyConfig {
    host: config.fms_host,
    port: config.fms_port,
    display_id: config.fms_display_id,
    admin_password: config.fms_admin_password,
  };

  cheesy::run(cheesy_config).await;
}
