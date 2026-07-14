use anyhow::Result;
use database::Database;
use once_cell::sync::OnceCell;

pub static DB: OnceCell<Database> = OnceCell::new();

pub async fn init_db(connection_str: Option<String>) -> Result<()> {
  // Check if the database is already initialized
  log::info!("Initializing database...");
  if DB.get().is_some() {
    log::warn!("Database is already initialized.");
    return Ok(());
  } else {
    // Initialize the database
    let db = match Database::new(connection_str).await {
      Ok(database) => database,
      Err(e) => {
        log::error!("Failed to initialize database: {}", e);
        return Err(e);
      }
    };

    // Set the global database instance
    match DB.set(db).map_err(|_| anyhow::anyhow!("Failed to set global database instance")) {
      Ok(_) => (),
      Err(e) => {
        log::error!("Failed to set global database instance: {}", e);
        return Err(e);
      }
    }
  }

  log::info!("Database initialized successfully.");
  Ok(())
}
