use std::net::IpAddr;

use clap::Parser;

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
}

impl ServerConfig {
  pub fn parse_from_cli() -> Self {
    Self::parse()
  }
}
