use anyhow::Result;

use crate::{db, generated::fms::FmsMatchInfo};

const FMS_STATE_TABLE: &str = "FMS_STATE";
const CURRENT_MATCH_KEY: &str = "current";

#[async_trait::async_trait]
pub trait FmsStateRepository {
  async fn update_current(info: &FmsMatchInfo) -> Result<String>;
  async fn get_current() -> Result<Option<FmsMatchInfo>>;
}

#[async_trait::async_trait]
impl FmsStateRepository for FmsMatchInfo {
  async fn update_current(info: &FmsMatchInfo) -> Result<String> {
    let db = db::DB.get().ok_or_else(|| anyhow::anyhow!("Database not initialized"))?;
    match db.get_table(FMS_STATE_TABLE).insert(Some(CURRENT_MATCH_KEY.to_string()), info, vec![], None).await {
      Ok(id) => Ok(id),
      Err(e) => Err(anyhow::anyhow!(e)),
    }
  }

  async fn get_current() -> Result<Option<FmsMatchInfo>> {
    let db = db::DB.get().ok_or_else(|| anyhow::anyhow!("Database not initialized"))?;
    match db.get_table(FMS_STATE_TABLE).get(CURRENT_MATCH_KEY.to_string()).await {
      Ok(record) => Ok(record),
      Err(e) => Err(anyhow::anyhow!(e)),
    }
  }
}
