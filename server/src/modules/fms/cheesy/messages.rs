// Cheesy Arena wire-format models.
//
// Mirrors the JSON payloads exchanged over Cheesy Arena's websockets. Internal to the
// cheesy connector - callers outside `modules::fms::cheesy` should only ever see the
// generated `reflink.fms` proto types.
//
// Source references (in the cheesy-arena Go project):
//   field/arena_notifiers.go  — arenaStatus, matchLoad, matchTime, matchTiming
//   model/match.go            — Match / MatchType
//   web/referee_panel.go      — addFoul / card / commitAndPost / toggleBypass commands
//   web/scoring_panel.go      — autoTower / endgame commands (game.TowerStatus)

use std::collections::HashMap;

use serde::{Deserialize, Serialize};

// --- WebSocket envelope ---
//
// Every Cheesy Arena websocket message is `{"type": "...", "data": {...}}`. Incoming
// messages are matched on the raw `serde_json::Value` in `client.rs` (the concrete type
// varies per `type`), so only the outgoing envelope needs a struct.

#[derive(Debug, Serialize)]
pub struct OutgoingMessage<T: Serialize> {
  #[serde(rename = "type")]
  pub msg_type: &'static str,
  pub data: T,
}

// --- arenaStatus ---

#[derive(Debug, Deserialize)]
#[serde(rename_all = "PascalCase")]
pub struct CheesyArenaStatus {
  pub match_id: i32,
  pub alliance_stations: HashMap<String, CheesyAllianceStation>,
  pub match_state: i32,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "PascalCase")]
pub struct CheesyAllianceStation {
  pub e_stop: bool,
  pub a_stop: bool,
  pub bypass: bool,
  pub team: Option<CheesyTeam>,
}

#[derive(Debug, Deserialize, Clone)]
#[serde(rename_all = "PascalCase")]
pub struct CheesyTeam {
  pub id: u32,
}

// --- matchLoad ---

#[derive(Debug)]
pub struct CheesyMatchLoad {
  pub match_: CheesyMatch,
  pub teams: HashMap<String, Option<CheesyTeam>>,
}

impl CheesyMatchLoad {
  pub fn from_value(v: &serde_json::Value) -> Option<Self> {
    let match_ = serde_json::from_value::<CheesyMatch>(v.get("Match")?.clone()).ok()?;
    let teams: HashMap<String, Option<CheesyTeam>> = serde_json::from_value(v.get("Teams")?.clone()).ok()?;
    Some(CheesyMatchLoad { match_, teams })
  }
}

#[derive(Debug, Deserialize, Clone)]
#[serde(rename_all = "PascalCase")]
pub struct CheesyMatch {
  pub id: i32,
  #[serde(rename = "Type")]
  pub match_type: i32,
  #[serde(default)]
  pub type_order: i32,
}

// --- eventStatus ---
//
// `cycle_time` is the elapsed time between the start of the last two matches (computed by
// Cheesy Arena when a match starts, not when it ends - see field/event_status.go), formatted
// as "M:SS" or "H:MM:SS", optionally followed by " (M:SS faster/slower than scheduled)". Empty
// when unknown (first match of the event, a big gap, or a test match).

#[derive(Debug, Deserialize)]
#[serde(rename_all = "PascalCase")]
pub struct CheesyEventStatus {
  #[serde(default)]
  pub cycle_time: String,
}

/// Parses a `cycle_time` string (see `CheesyEventStatus`) into a duration in seconds.
pub fn parse_cycle_time_sec(raw: &str) -> Option<i64> {
  let core = raw.split(" (").next().unwrap_or(raw).trim();
  if core.is_empty() {
    return None;
  }

  let parts: Vec<i64> = core.split(':').map(str::parse).collect::<Result<_, _>>().ok()?;
  match parts.as_slice() {
    [minutes, seconds] => Some(minutes * 60 + seconds),
    [hours, minutes, seconds] => Some(hours * 3600 + minutes * 60 + seconds),
    _ => None,
  }
}

// --- matchTime ---

#[derive(Debug, Deserialize)]
#[serde(rename_all = "PascalCase")]
pub struct CheesyMatchTime {
  pub match_state: i32,
  pub match_time_sec: i32,
}

// --- matchTiming (static per-event period durations, used to compute time remaining) ---

#[derive(Debug, Deserialize, Clone)]
#[serde(rename_all = "PascalCase")]
pub struct CheesyMatchTiming {
  #[serde(default = "default_auto")]
  pub auto_duration_sec: i32,
  #[serde(default = "default_pause")]
  pub pause_duration_sec: i32,
  #[serde(default = "default_transition")]
  pub transition_shift_duration_sec: i32,
  #[serde(default = "default_shift")]
  pub shift_duration_sec: i32,
  #[serde(default = "default_endgame")]
  pub endgame_duration_sec: i32,
}

fn default_auto() -> i32 {
  15
}
fn default_pause() -> i32 {
  3
}
fn default_transition() -> i32 {
  10
}
fn default_shift() -> i32 {
  25
}
fn default_endgame() -> i32 {
  30
}

impl Default for CheesyMatchTiming {
  fn default() -> Self {
    Self {
      auto_duration_sec: default_auto(),
      pause_duration_sec: default_pause(),
      transition_shift_duration_sec: default_transition(),
      shift_duration_sec: default_shift(),
      endgame_duration_sec: default_endgame(),
    }
  }
}

impl CheesyMatchTiming {
  pub fn teleop_duration_sec(&self) -> i32 {
    self.transition_shift_duration_sec + 4 * self.shift_duration_sec + self.endgame_duration_sec
  }
}

// --- Match state constants (mirrors cheesy-arena's field.MatchState iota) ---
// PreMatch (0) and StartMatch (1) aren't referenced directly; they fall through to the
// default PreMatch mapping in `client.rs::map_match_phase`.

pub const STATE_AUTO_PERIOD: i32 = 2;
pub const STATE_PAUSE_PERIOD: i32 = 3;
pub const STATE_TELEOP_PERIOD: i32 = 4;
pub const STATE_POST_MATCH: i32 = 5;
pub const STATE_TIMEOUT_ACTIVE: i32 = 6;
pub const STATE_POST_TIMEOUT: i32 = 7;

// --- Match type constants (mirrors cheesy-arena's model.MatchType iota) ---
// Test (0) isn't referenced directly; it falls through to the default Unspecified mapping.

pub const MATCH_TYPE_PRACTICE: i32 = 1;
pub const MATCH_TYPE_QUALIFICATION: i32 = 2;
pub const MATCH_TYPE_PLAYOFF: i32 = 3;

// --- Outgoing referee panel commands ---

#[derive(Debug, Serialize)]
#[serde(rename_all = "PascalCase")]
pub struct AddFoulCommand {
  pub alliance: &'static str,
  pub is_major: bool,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "PascalCase")]
pub struct DeleteFoulCommand {
  pub alliance: &'static str,
  pub index: i32,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "PascalCase")]
pub struct CardCommand {
  pub alliance: &'static str,
  pub team_id: i32,
  pub card: &'static str,
}

// --- Outgoing scoring panel commands (game.TowerStatus: None=0, Level1=1, Level2=2, Level3=3) ---

pub const TOWER_STATUS_NONE: i32 = 0;
pub const TOWER_STATUS_LEVEL_1: i32 = 1;
pub const TOWER_STATUS_LEVEL_2: i32 = 2;
pub const TOWER_STATUS_LEVEL_3: i32 = 3;

#[derive(Debug, Serialize)]
#[serde(rename_all = "PascalCase")]
pub struct AutoTowerCommand {
  pub team_position: i32,
  pub auto_tower_status: i32,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "PascalCase")]
pub struct EndgameCommand {
  pub team_position: i32,
  pub endgame_tower_status: i32,
}
