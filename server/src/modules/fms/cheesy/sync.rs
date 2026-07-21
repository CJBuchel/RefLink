use tokio::sync::{broadcast, mpsc, watch};
use tokio_tungstenite::tungstenite::Message;

use crate::{
  core::events::{ChangeEvent, EVENT_BUS},
  generated::{
    common::{
      AutoClimbState, CardType, EndgameClimbState, FieldState, HeadRefereePanelState, MatchFouls, RefereePanelState,
      TeamAllianceStationType,
    },
    db::MatchStateRecord,
    fms::FmsMatchInfo,
  },
};

use super::messages::{
  AddFoulCommand, AutoTowerCommand, CardCommand, DeleteFoulCommand, EndgameCommand, OutgoingMessage, TOWER_STATUS_LEVEL_1,
  TOWER_STATUS_LEVEL_2, TOWER_STATUS_LEVEL_3, TOWER_STATUS_NONE,
};
use serde::Serialize;

/// A local mirror of the order fouls were pushed to Cheesy Arena for one alliance, so a
/// count decrease (a referee correcting a call) can be translated into a `deleteFoul
/// {Index}` command. This assumes Cheesy Arena's own foul list matches exactly what we've
/// sent it - i.e. nothing else (a scoring panel, a manual edit in Cheesy's own referee UI)
/// is concurrently adding/removing fouls for the same match.
#[derive(Default)]
struct FoulLedger {
  red: Vec<bool>,
  blue: Vec<bool>,
}

/// The combined referee-state fields Cheesy Arena actually cares about, reduced from the
/// five panel records (head referee + the four near/far panels).
#[derive(Clone, Default, PartialEq)]
struct CombinedRefereeState {
  red_minor_fouls: i32,
  red_major_fouls: i32,
  blue_minor_fouls: i32,
  blue_major_fouls: i32,
  red_1: CardType,
  red_2: CardType,
  red_3: CardType,
  blue_1: CardType,
  blue_2: CardType,
  blue_3: CardType,
}

fn merge_fouls(combined: &mut CombinedRefereeState, fouls: Option<&MatchFouls>) {
  if let Some(f) = fouls {
    combined.red_minor_fouls = combined.red_minor_fouls.max(f.red_minor_fouls);
    combined.red_major_fouls = combined.red_major_fouls.max(f.red_major_fouls);
    combined.blue_minor_fouls = combined.blue_minor_fouls.max(f.blue_minor_fouls);
    combined.blue_major_fouls = combined.blue_major_fouls.max(f.blue_major_fouls);
  }
}

// Fouls are combined across every panel (head referee included) by taking the highest
// count any single panel has reported per field - near/far panels call fouls independently
// and the head referee's own count is just one more input until they can review and adjust it.
//
// Cards are different: they're sourced *only* from the head referee's panel (a distinct
// `HeadRefereePanelState`, not a `RefereePanelState` like the other four). The near/far
// panels' card fields are for on-panel display/discussion during the match - only the head
// referee actually decides and submits a card, typically once the match is over.
fn combine_match_state(record: &MatchStateRecord) -> CombinedRefereeState {
  let mut combined = CombinedRefereeState::default();

  if let Some(hr) = record.hr.as_ref() {
    merge_fouls(&mut combined, hr.match_fouls.as_ref());
  }

  let panels = [record.rn.as_ref(), record.rf.as_ref(), record.bn.as_ref(), record.bf.as_ref()];
  for panel in panels.into_iter().flatten() {
    merge_fouls(&mut combined, panel.match_fouls.as_ref());
  }

  if let Some(cards) = record.hr.as_ref().and_then(|hr| hr.match_cards.as_ref()) {
    combined.red_1 = CardType::try_from(cards.red_alliance_station_1).unwrap_or_default();
    combined.red_2 = CardType::try_from(cards.red_alliance_station_2).unwrap_or_default();
    combined.red_3 = CardType::try_from(cards.red_alliance_station_3).unwrap_or_default();
    combined.blue_1 = CardType::try_from(cards.blue_alliance_station_1).unwrap_or_default();
    combined.blue_2 = CardType::try_from(cards.blue_alliance_station_2).unwrap_or_default();
    combined.blue_3 = CardType::try_from(cards.blue_alliance_station_3).unwrap_or_default();
  }

  combined
}

fn is_red_station(s: TeamAllianceStationType) -> bool {
  matches!(s, TeamAllianceStationType::Red1 | TeamAllianceStationType::Red2 | TeamAllianceStationType::Red3)
}

// Climb is an enum per station, not a count like fouls - two panels can't have their calls
// "combined", they have to actually agree. Endgame already enforces that agreement client-side
// before submission is even allowed; auto instead keeps both panels' calls in sync live as
// they're entered (see client's auto_climb_column.dart), so there's nothing to reconcile here.
// Rather than track a "combined" alliance state, each panel is diffed against its own previous
// snapshot: whichever panel's (submitted, climb) pair just changed is the one that gets pushed,
// using its own values - since panel updates are processed in the order they happened, this
// means whoever submitted (or corrected) most recently always wins, which is the desired
// "last submit wins" behaviour even in the rare case the two calls briefly disagree.
#[derive(Clone, Default, PartialEq)]
struct PanelClimbState {
  auto_submitted: bool,
  auto_climb: [i32; 3],
  endgame_submitted: bool,
  endgame_climb: [i32; 3],
}

fn panel_climb_state(panel: Option<&RefereePanelState>) -> PanelClimbState {
  let Some(panel) = panel else { return PanelClimbState::default() };
  let auto = panel.auto_climb.as_ref();
  let endgame = panel.endgame_climb.as_ref();

  PanelClimbState {
    auto_submitted: panel.auto_submitted,
    auto_climb: [
      auto.map(|a| a.auto_climb_alliance_station_1).unwrap_or_default(),
      auto.map(|a| a.auto_climb_alliance_station_2).unwrap_or_default(),
      auto.map(|a| a.auto_climb_alliance_station_3).unwrap_or_default(),
    ],
    endgame_submitted: panel.endgame_submitted,
    endgame_climb: [
      endgame.map(|e| e.endgame_climb_alliance_station_1).unwrap_or_default(),
      endgame.map(|e| e.endgame_climb_alliance_station_2).unwrap_or_default(),
      endgame.map(|e| e.endgame_climb_alliance_station_3).unwrap_or_default(),
    ],
  }
}

// Auto climb only ever reaches "Nothing" or "Level1" (see AutoClimbState) - Unspecified means
// no call was made (e.g. a bypassed station never gets one), so it's skipped rather than
// guessed at.
fn auto_climb_to_tower_status(raw: i32) -> Option<i32> {
  match AutoClimbState::try_from(raw).unwrap_or_default() {
    AutoClimbState::Nothing => Some(TOWER_STATUS_NONE),
    AutoClimbState::Level1 => Some(TOWER_STATUS_LEVEL_1),
    AutoClimbState::Unspecified => None,
  }
}

fn endgame_climb_to_tower_status(raw: i32) -> Option<i32> {
  match EndgameClimbState::try_from(raw).unwrap_or_default() {
    EndgameClimbState::Nothing => Some(TOWER_STATUS_NONE),
    EndgameClimbState::Level1 => Some(TOWER_STATUS_LEVEL_1),
    EndgameClimbState::Level2 => Some(TOWER_STATUS_LEVEL_2),
    EndgameClimbState::Level3 => Some(TOWER_STATUS_LEVEL_3),
    EndgameClimbState::Unspecified => None,
  }
}

fn push_auto_tower_commands(commands: &mut Vec<Message>, climb: &[i32; 3]) {
  for (i, &raw) in climb.iter().enumerate() {
    if let Some(status) = auto_climb_to_tower_status(raw) {
      commands.push(encode("autoTower", AutoTowerCommand { team_position: i as i32 + 1, auto_tower_status: status }));
    }
  }
}

fn push_endgame_tower_commands(commands: &mut Vec<Message>, climb: &[i32; 3]) {
  for (i, &raw) in climb.iter().enumerate() {
    if let Some(status) = endgame_climb_to_tower_status(raw) {
      commands.push(encode("endgame", EndgameCommand { team_position: i as i32 + 1, endgame_tower_status: status }));
    }
  }
}

/// Diffs one alliance's near/far panels against their previous snapshots and pushes climb
/// commands for whichever panel(s) just became submitted or changed their submitted call.
fn push_alliance_climb_commands(commands: &mut Vec<Message>, prev_near: &PanelClimbState, near: &PanelClimbState, prev_far: &PanelClimbState, far: &PanelClimbState) {
  if near.auto_submitted && (near.auto_submitted, near.auto_climb) != (prev_near.auto_submitted, prev_near.auto_climb) {
    push_auto_tower_commands(commands, &near.auto_climb);
  }
  if far.auto_submitted && (far.auto_submitted, far.auto_climb) != (prev_far.auto_submitted, prev_far.auto_climb) {
    push_auto_tower_commands(commands, &far.auto_climb);
  }
  if near.endgame_submitted && (near.endgame_submitted, near.endgame_climb) != (prev_near.endgame_submitted, prev_near.endgame_climb) {
    push_endgame_tower_commands(commands, &near.endgame_climb);
  }
  if far.endgame_submitted && (far.endgame_submitted, far.endgame_climb) != (prev_far.endgame_submitted, prev_far.endgame_climb) {
    push_endgame_tower_commands(commands, &far.endgame_climb);
  }
}

fn encode<T: Serialize>(msg_type: &'static str, data: T) -> Message {
  let payload = OutgoingMessage { msg_type, data };
  Message::Text(serde_json::to_string(&payload).unwrap_or_default().into())
}

fn push_foul_deltas(commands: &mut Vec<Message>, ledger: &mut Vec<bool>, alliance: &'static str, is_major: bool, previous: i32, current: i32) {
  if current > previous {
    for _ in 0..(current - previous) {
      ledger.push(is_major);
      commands.push(encode("addFoul", AddFoulCommand { alliance, is_major }));
    }
  } else if current < previous {
    for _ in 0..(previous - current) {
      match ledger.iter().rposition(|&entry_is_major| entry_is_major == is_major) {
        Some(index) => {
          ledger.remove(index);
          commands.push(encode("deleteFoul", DeleteFoulCommand { alliance, index: index as i32 }));
        }
        None => {
          let kind = if is_major { "major" } else { "minor" };
          log::warn!(
            "[FMS/sync] No tracked {alliance} {kind} foul left to delete; local mirror is out of sync with Cheesy Arena"
          );
        }
      }
    }
  }
}

fn push_card_command(
  commands: &mut Vec<Message>,
  match_info: Option<&FmsMatchInfo>,
  station: TeamAllianceStationType,
  previous: CardType,
  current: CardType,
) {
  if previous == current {
    return;
  }

  let Some(match_info) = match_info else {
    log::warn!("[FMS/sync] Dropping card update for {station:?}; no match info from Cheesy Arena yet");
    return;
  };
  let Some(team) = match_info.teams.iter().find(|t| t.alliance_station == station as i32) else {
    log::warn!("[FMS/sync] Dropping card update for {station:?}; team unknown");
    return;
  };

  let alliance = if is_red_station(station) { "red" } else { "blue" };
  let card = match current {
    CardType::Yellow => "yellow",
    CardType::Red => "red",
    CardType::Unspecified => "",
  };

  commands.push(encode("card", CardCommand { alliance, team_id: team.team_number, card }));
}

// field_state is one-way (MATCH -> COUNT -> RESET, enforced in arena::update_head_referee_state),
// so each transition maps to exactly one Cheesy signal, sent once when it's first observed.
fn field_state_command(state: FieldState) -> Option<Message> {
  match state {
    FieldState::Count => Some(encode("signalVolunteers", ())),
    FieldState::Reset => Some(encode("signalReset", ())),
    FieldState::Match => None,
  }
}

fn cheesy_station_key(station: TeamAllianceStationType) -> Option<&'static str> {
  match station {
    TeamAllianceStationType::Red1 => Some("R1"),
    TeamAllianceStationType::Red2 => Some("R2"),
    TeamAllianceStationType::Red3 => Some("R3"),
    TeamAllianceStationType::Blue1 => Some("B1"),
    TeamAllianceStationType::Blue2 => Some("B2"),
    TeamAllianceStationType::Blue3 => Some("B3"),
    TeamAllianceStationType::Unspecified => None,
  }
}

#[derive(Clone, Copy, Default, PartialEq)]
struct BypassState {
  red: [bool; 3],
  blue: [bool; 3],
}

fn bypass_state(hr: Option<&HeadRefereePanelState>) -> BypassState {
  let Some(hr) = hr else { return BypassState::default() };
  let red = hr.red_bypass.as_ref();
  let blue = hr.blue_bypass.as_ref();
  BypassState {
    red: [
      red.is_some_and(|b| b.station_1),
      red.is_some_and(|b| b.station_2),
      red.is_some_and(|b| b.station_3),
    ],
    blue: [
      blue.is_some_and(|b| b.station_1),
      blue.is_some_and(|b| b.station_2),
      blue.is_some_and(|b| b.station_3),
    ],
  }
}

// The head referee's bypass flag is treated the same way as field_state: whichever way a
// station's flag flips, Cheesy Arena's own `toggleBypass` is a toggle rather than a "set to
// X" - so this only stays correct as long as nothing else (Cheesy's native UI, a field
// restart) flips the actual bypass state out from under us in between.
fn push_bypass_commands(commands: &mut Vec<Message>, previous: &BypassState, current: &BypassState) {
  const RED_STATIONS: [TeamAllianceStationType; 3] =
    [TeamAllianceStationType::Red1, TeamAllianceStationType::Red2, TeamAllianceStationType::Red3];
  const BLUE_STATIONS: [TeamAllianceStationType; 3] =
    [TeamAllianceStationType::Blue1, TeamAllianceStationType::Blue2, TeamAllianceStationType::Blue3];

  for (i, station) in RED_STATIONS.into_iter().enumerate() {
    if previous.red[i] != current.red[i]
      && let Some(key) = cheesy_station_key(station)
    {
      commands.push(encode("toggleBypass", key));
    }
  }
  for (i, station) in BLUE_STATIONS.into_iter().enumerate() {
    if previous.blue[i] != current.blue[i]
      && let Some(key) = cheesy_station_key(station)
    {
      commands.push(encode("toggleBypass", key));
    }
  }
}

fn diff_commands(
  previous: &CombinedRefereeState,
  current: &CombinedRefereeState,
  match_info: Option<&FmsMatchInfo>,
  ledger: &mut FoulLedger,
) -> Vec<Message> {
  let mut commands = Vec::new();

  push_foul_deltas(&mut commands, &mut ledger.red, "red", false, previous.red_minor_fouls, current.red_minor_fouls);
  push_foul_deltas(&mut commands, &mut ledger.red, "red", true, previous.red_major_fouls, current.red_major_fouls);
  push_foul_deltas(&mut commands, &mut ledger.blue, "blue", false, previous.blue_minor_fouls, current.blue_minor_fouls);
  push_foul_deltas(&mut commands, &mut ledger.blue, "blue", true, previous.blue_major_fouls, current.blue_major_fouls);

  push_card_command(&mut commands, match_info, TeamAllianceStationType::Red1, previous.red_1, current.red_1);
  push_card_command(&mut commands, match_info, TeamAllianceStationType::Red2, previous.red_2, current.red_2);
  push_card_command(&mut commands, match_info, TeamAllianceStationType::Red3, previous.red_3, current.red_3);
  push_card_command(&mut commands, match_info, TeamAllianceStationType::Blue1, previous.blue_1, current.blue_1);
  push_card_command(&mut commands, match_info, TeamAllianceStationType::Blue2, previous.blue_2, current.blue_2);
  push_card_command(&mut commands, match_info, TeamAllianceStationType::Blue3, previous.blue_3, current.blue_3);

  commands
}

/// Subscribes to `MatchStateRecord` changes (published whenever a referee panel updates its
/// state) and relays the combined foul/card counts to Cheesy Arena's referee panel websocket
/// via `referee_cmd_tx`, and auto/endgame climb calls to the relevant alliance's scoring panel
/// websocket via `red_scoring_cmd_tx`/`blue_scoring_cmd_tx`.
pub async fn run(
  match_info_rx: watch::Receiver<Option<FmsMatchInfo>>,
  referee_cmd_tx: mpsc::Sender<Message>,
  red_scoring_cmd_tx: mpsc::Sender<Message>,
  blue_scoring_cmd_tx: mpsc::Sender<Message>,
  mut shutdown_rx: broadcast::Receiver<()>,
) {
  let Some(bus) = EVENT_BUS.get() else {
    log::error!("[FMS/sync] Event bus not initialized");
    return;
  };
  let mut state_rx = match bus.subscribe::<MatchStateRecord>() {
    Ok(rx) => rx,
    Err(e) => {
      log::error!("[FMS/sync] Failed to subscribe to match state events: {e}");
      return;
    }
  };

  let mut last_sent = CombinedRefereeState::default();
  let mut ledger = FoulLedger::default();
  let mut current_match_id: Option<i32> = None;
  let mut last_field_state = FieldState::Match;
  let mut last_bypass = BypassState::default();
  let mut prev_rn = PanelClimbState::default();
  let mut prev_rf = PanelClimbState::default();
  let mut prev_bn = PanelClimbState::default();
  let mut prev_bf = PanelClimbState::default();

  loop {
    tokio::select! {
      event = state_rx.recv() => {
        let record = match event {
          Ok(ChangeEvent::Record { data: Some(record), .. }) => record,
          Ok(_) => continue,
          Err(broadcast::error::RecvError::Lagged(n)) => {
            log::warn!("[FMS/sync] Lagged behind by {n} match state events");
            continue;
          }
          Err(broadcast::error::RecvError::Closed) => return,
        };

        // Cheesy Arena resets its own foul list (and score) whenever it loads a new match, so
        // our notion of "previously sent" has to reset right along with it - otherwise the
        // first update of a new match would look like a huge decrease from the last match and
        // spam deleteFoul commands into an already-empty list, or skip pushing a climb call
        // that looks unchanged from the last match. field_state resets to MATCH for the same
        // reason (it's per-match-cycle, enforced in the repository layer).
        if current_match_id != Some(record.match_id) {
          current_match_id = Some(record.match_id);
          last_sent = CombinedRefereeState::default();
          ledger = FoulLedger::default();
          last_field_state = FieldState::Match;
          last_bypass = BypassState::default();
          prev_rn = PanelClimbState::default();
          prev_rf = PanelClimbState::default();
          prev_bn = PanelClimbState::default();
          prev_bf = PanelClimbState::default();
        }

        let field_state = record.hr.as_ref().and_then(|hr| FieldState::try_from(hr.field_state).ok()).unwrap_or_default();
        if field_state != last_field_state {
          if let Some(message) = field_state_command(field_state)
            && referee_cmd_tx.send(message).await.is_err()
          {
            log::warn!("[FMS/sync] Referee panel channel closed, dropping command");
          }
          last_field_state = field_state;
        }

        let bypass = bypass_state(record.hr.as_ref());
        if bypass != last_bypass {
          let mut bypass_commands = Vec::new();
          push_bypass_commands(&mut bypass_commands, &last_bypass, &bypass);
          for message in bypass_commands {
            if referee_cmd_tx.send(message).await.is_err() {
              log::warn!("[FMS/sync] Referee panel channel closed, dropping command");
              break;
            }
          }
          last_bypass = bypass;
        }

        let combined = combine_match_state(&record);
        if combined != last_sent {
          let match_info = match_info_rx.borrow().clone();
          let commands = diff_commands(&last_sent, &combined, match_info.as_ref(), &mut ledger);
          for message in commands {
            if referee_cmd_tx.send(message).await.is_err() {
              log::warn!("[FMS/sync] Referee panel channel closed, dropping command");
              break;
            }
          }

          last_sent = combined;
        }

        let rn = panel_climb_state(record.rn.as_ref());
        let rf = panel_climb_state(record.rf.as_ref());
        let bn = panel_climb_state(record.bn.as_ref());
        let bf = panel_climb_state(record.bf.as_ref());

        let mut red_climb_commands = Vec::new();
        push_alliance_climb_commands(&mut red_climb_commands, &prev_rn, &rn, &prev_rf, &rf);
        for message in red_climb_commands {
          if red_scoring_cmd_tx.send(message).await.is_err() {
            log::warn!("[FMS/sync] Red scoring panel channel closed, dropping command");
            break;
          }
        }

        let mut blue_climb_commands = Vec::new();
        push_alliance_climb_commands(&mut blue_climb_commands, &prev_bn, &bn, &prev_bf, &bf);
        for message in blue_climb_commands {
          if blue_scoring_cmd_tx.send(message).await.is_err() {
            log::warn!("[FMS/sync] Blue scoring panel channel closed, dropping command");
            break;
          }
        }

        prev_rn = rn;
        prev_rf = rf;
        prev_bn = bn;
        prev_bf = bf;
      }
      _ = shutdown_rx.recv() => return,
    }
  }
}
