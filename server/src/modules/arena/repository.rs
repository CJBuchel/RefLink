use anyhow::Result;

use crate::{
  core::events::{ChangeEvent, ChangeOperation, EVENT_BUS},
  db,
  generated::{
    common::{PanelType, RefereePanelState},
    db::MatchStateRecord,
  },
};

const MATCH_STATE_TABLE: &str = "MATCH_STATE";

#[async_trait::async_trait]
pub trait MatchStateRepository {
  async fn update_match_state(match_id: i32, record: MatchStateRecord) -> Result<String>;
  async fn get_match_state(match_id: i32) -> Result<MatchStateRecord>;
  async fn update_panel_state(match_id: i32, panel_type: PanelType, record: RefereePanelState) -> Result<String>;
}

#[async_trait::async_trait]
impl MatchStateRepository for MatchStateRecord {
  async fn update_match_state(match_id: i32, record: MatchStateRecord) -> Result<String> {
    let db = db::DB.get().ok_or_else(|| anyhow::anyhow!("Database not initialized"))?;
    let id = match db.get_table(MATCH_STATE_TABLE).insert(Some(match_id.to_string()), &record, vec![], None).await {
      Ok(id) => id,
      Err(e) => return Err(anyhow::anyhow!(e)),
    };

    if let Some(bus) = EVENT_BUS.get() {
      let _ = bus.publish(ChangeEvent::Record {
        operation: ChangeOperation::Update,
        id: id.clone(),
        data: Some(record),
      });
    }

    Ok(id)
  }

  async fn get_match_state(match_id: i32) -> Result<MatchStateRecord> {
    let db = db::DB.get().ok_or_else(|| anyhow::anyhow!("Database not initialized"))?;
    log::info!("Getting record");
    match db.get_table(MATCH_STATE_TABLE).get(match_id.to_string()).await {
      Ok(Some(record)) => Ok(record),
      Ok(None) => {
        log::warn!("No record found for id: {}", match_id);
        let new_match_state = MatchStateRecord { match_id, ..Default::default() };
        let id = Self::update_match_state(match_id, new_match_state).await?;
        log::info!("Created new record with id: {}", id);
        match db.get_table(MATCH_STATE_TABLE).get(id).await? {
          Some(record) => Ok(record),
          None => Err(anyhow::anyhow!("Failed to get match state")),
        }
      }
      Err(e) => Err(anyhow::anyhow!(e)),
    }
  }

  async fn update_panel_state(match_id: i32, panel_type: PanelType, record: RefereePanelState) -> Result<String> {
    let mut match_state = Self::get_match_state(match_id).await?;
    match panel_type {
      PanelType::HeadReferee => match_state.hr = Some(record),
      PanelType::RedNear => match_state.rn = Some(record),
      PanelType::RedFar => match_state.rf = Some(record),
      PanelType::BlueNear => match_state.bn = Some(record),
      PanelType::BlueFar => match_state.bf = Some(record),
      _ => {}
    }

    Self::update_match_state(match_id, match_state).await
  }
}
