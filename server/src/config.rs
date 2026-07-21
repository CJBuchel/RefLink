use std::net::IpAddr;

use clap::Parser;
use once_cell::sync::OnceCell;

#[derive(Parser, Debug, Clone)]
#[command(version, about, long_about = None)]
pub struct ServerConfig {
  /// Binding Ip Address
  #[arg(short, long, default_value = "0.0.0.0")]
  pub addr: IpAddr,

  /// Binding Port for the web server
  #[arg(short, long, default_value_t = 8080)]
  pub web_port: u16,

  /// Binding Port for the gRPC endpoint
  #[arg(long, default_value_t = 50051)]
  pub api_port: u16,

  /// Number of matches before rotation
  #[arg(long, default_value_t = 5)]
  pub match_rotations: u16,

  /// Redis connection string
  #[arg(long, env, default_value = "redis://127.0.0.1/")]
  pub redis_url: String,

  /// Enable the FMS (Cheesy Arena) connector
  #[arg(long, env, default_value_t = true)]
  pub fms_enabled: bool,

  /// Hostname/IP of the Cheesy Arena server
  #[arg(long, env, default_value = "127.0.0.1")]
  pub fms_host: String,

  /// Port of the Cheesy Arena web server
  #[arg(long, env, default_value_t = 8080)]
  pub fms_port: u16,

  /// Display id to identify this client on the field_monitor websocket
  #[arg(long, env, default_value_t = 5333)]
  pub fms_display_id: u32,

  /// Cheesy Arena admin password (required to authenticate the referee panel websocket
  /// unless the event has no admin password configured)
  #[arg(long, env)]
  pub fms_admin_password: Option<String>,
}

impl ServerConfig {
  pub fn parse_from_cli() -> Self {
    Self::parse()
  }
}

pub static CONFIG: OnceCell<ServerConfig> = OnceCell::new();

pub fn init_config(config: ServerConfig) {
  let _ = CONFIG.set(config);
}
