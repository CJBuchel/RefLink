use anyhow::Result;
use redis::{AsyncCommands, aio::MultiplexedConnection};

use crate::Table;

pub struct Database {
  db_connection: MultiplexedConnection,
  // tables: some type of table list and representation
}

impl Database {
  pub async fn new(connection_str: Option<String>) -> Result<Self> {
    let connection_str = connection_str.unwrap_or_else(|| "redis://127.0.0.1/".to_string());

    log::info!("Opening database connection: {}", connection_str);

    let client = match redis::Client::open(connection_str) {
      Ok(c) => c,
      Err(e) => {
        log::error!("Failed to create Redis client: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    let redis_config = redis::AsyncConnectionConfig::default()
      .set_connection_timeout(Some(std::time::Duration::from_secs(10)))
      .set_response_timeout(Some(std::time::Duration::from_secs(10)));

    let mut con = match client.get_multiplexed_async_connection_with_config(&redis_config).await {
      Ok(c) => c,
      Err(e) => {
        log::error!("Failed to connect to Redis: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    let _: String = match con.ping().await {
      Ok(p) => p,
      Err(e) => {
        log::error!("Failed to ping Redis: {}", e);
        return Err(anyhow::anyhow!(e));
      }
    };

    return Ok(Database { db_connection: con });
  }

  // Get a table connection
  pub fn get_table(&self, name: &str) -> Table {
    Table::get_table(name, self.db_connection.clone())
  }
}
