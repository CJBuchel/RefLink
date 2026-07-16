use anyhow::Result;

use crate::{
  core::events::{ChangeEvent, ChangeOperation, EVENT_BUS},
  db,
  generated::{
    common::{HeadRefereePanelState, PanelType, RefereePanelState},
    db::MatchStateRecord,
  },
};

const MATCH_STATE_TABLE: &str = "MATCH_STATE";
const COMPLETED_INDEX: &str = "completed";

#[async_trait::async_trait]
pub trait MatchStateRepository {
  async fn update_match_state(match_id: i32, record: MatchStateRecord) -> Result<String>;
  async fn get_match_state(match_id: i32) -> Result<MatchStateRecord>;
  async fn update_panel_state(match_id: i32, panel_type: PanelType, record: RefereePanelState) -> Result<String>;
  async fn update_head_referee_state(match_id: i32, record: HeadRefereePanelState) -> Result<String>;
  async fn mark_match_completed(match_id: i32) -> Result<String>;
  async fn count_matches() -> Result<usize>;
  async fn compute_rotation(match_rotations: u16) -> Result<(bool, i32)>;
}

#[async_trait::async_trait]
impl MatchStateRepository for MatchStateRecord {
  async fn update_match_state(match_id: i32, record: MatchStateRecord) -> Result<String> {
    let db = db::DB.get().ok_or_else(|| anyhow::anyhow!("Database not initialized"))?;
    // Only completed matches carry the search index, so `count_matches` can count actually-
    // played matches without a full table scan. A match is never un-completed, so this
    // never needs to be retracted.
    let search_indexes = if record.completed { vec![COMPLETED_INDEX.to_string()] } else { vec![] };
    let id = match db.get_table(MATCH_STATE_TABLE).insert(Some(match_id.to_string()), &record, search_indexes, None).await {
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
      PanelType::RedNear => match_state.rn = Some(record),
      PanelType::RedFar => match_state.rf = Some(record),
      PanelType::BlueNear => match_state.bn = Some(record),
      PanelType::BlueFar => match_state.bf = Some(record),
      _ => {}
    }

    Self::update_match_state(match_id, match_state).await
  }

  async fn update_head_referee_state(match_id: i32, mut record: HeadRefereePanelState) -> Result<String> {
    let mut match_state = Self::get_match_state(match_id).await?;

    // field_state can freely switch between COUNT and RESET - the head referee needs to be
    // able to correct an accidental press without being locked in. Each change still relays
    // the corresponding signalVolunteers/signalReset to Cheesy Arena (see fms/cheesy/sync.rs).

    // The 2-minute warning stays one-way - once given, it stays given for this match. Stamp
    // the countdown deadline the instant it first becomes true, and preserve that original
    // deadline on any later resend (every mutator resends the whole local state, so without
    // this a later field_state toggle would otherwise overwrite it with 0 from the client).
    let was_given = match_state.hr.as_ref().is_some_and(|hr| hr.two_minute_warning_given);
    record.two_minute_warning_given |= was_given;

    record.two_minute_warning_expires_at_unix_sec = if !record.two_minute_warning_given {
      0
    } else if was_given {
      match_state.hr.as_ref().map(|hr| hr.two_minute_warning_expires_at_unix_sec).unwrap_or(0)
    } else {
      let now = std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).unwrap_or_default().as_secs() as i64;
      now + 120
    };

    match_state.hr = Some(record);
    Self::update_match_state(match_id, match_state).await
  }

  async fn mark_match_completed(match_id: i32) -> Result<String> {
    let mut match_state = Self::get_match_state(match_id).await?;
    match_state.completed = true;
    Self::update_match_state(match_id, match_state).await
  }

  // Merely loading/previewing a match already creates a MatchStateRecord (see
  // get_match_state's auto-create-on-miss), so counting every record would count matches
  // that were never actually played. Count only ones that reached PostMatch (see
  // mark_match_completed).
  async fn count_matches() -> Result<usize> {
    let db = db::DB.get().ok_or_else(|| anyhow::anyhow!("Database not initialized"))?;
    let completed: std::collections::HashMap<String, MatchStateRecord> =
      db.get_table(MATCH_STATE_TABLE).get_by_search_index(COMPLETED_INDEX.to_string()).await?;
    Ok(completed.len())
  }

  // Derives "matches since last rotation" from how many completed matches have ever been
  // persisted, rather than keeping a separate counter - it survives restarts for free.
  async fn compute_rotation(match_rotations: u16) -> Result<(bool, i32)> {
    if match_rotations == 0 {
      return Ok((false, 0));
    }

    let match_rotations = i32::from(match_rotations);
    let matches_passed = Self::count_matches().await? as i32;
    let remainder = matches_passed % match_rotations;

    if matches_passed > 0 && remainder == 0 {
      Ok((true, 0))
    } else {
      Ok((false, match_rotations - remainder))
    }
  }
}
