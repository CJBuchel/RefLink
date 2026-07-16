use tokio::sync::{broadcast, mpsc, watch};
use tokio_tungstenite::tungstenite::Message;

use crate::{
  core::events::{ChangeEvent, EVENT_BUS},
  generated::{
    common::{CardType, FieldState, MatchFouls, TeamAllianceStationType},
    db::MatchStateRecord,
    fms::FmsMatchInfo,
  },
};

use super::messages::{AddFoulCommand, CardCommand, DeleteFoulCommand, OutgoingMessage};
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

/// Subscribes to `MatchStateRecord` changes (published whenever a referee panel updates
/// its state) and relays the combined foul/card counts to Cheesy Arena's referee panel
/// websocket via `cmd_tx`.
pub async fn run(
  match_info_rx: watch::Receiver<Option<FmsMatchInfo>>,
  cmd_tx: mpsc::Sender<Message>,
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

        // Cheesy Arena resets its own foul list whenever it loads a new match, so our
        // notion of "previously sent" has to reset right along with it - otherwise the
        // first update of a new match would look like a huge decrease from the last match
        // and spam deleteFoul commands into an already-empty list. field_state resets to
        // MATCH for the same reason (it's per-match-cycle, enforced in the repository layer).
        if current_match_id != Some(record.match_id) {
          current_match_id = Some(record.match_id);
          last_sent = CombinedRefereeState::default();
          ledger = FoulLedger::default();
          last_field_state = FieldState::Match;
        }

        let field_state = record.hr.as_ref().and_then(|hr| FieldState::try_from(hr.field_state).ok()).unwrap_or_default();
        if field_state != last_field_state {
          if let Some(message) = field_state_command(field_state)
            && cmd_tx.send(message).await.is_err()
          {
            log::warn!("[FMS/sync] Referee panel channel closed, dropping command");
          }
          last_field_state = field_state;
        }

        let combined = combine_match_state(&record);
        if combined != last_sent {
          let match_info = match_info_rx.borrow().clone();
          let commands = diff_commands(&last_sent, &combined, match_info.as_ref(), &mut ledger);
          for message in commands {
            if cmd_tx.send(message).await.is_err() {
              log::warn!("[FMS/sync] Referee panel channel closed, dropping command");
              break;
            }
          }

          last_sent = combined;
        }
      }
      _ = shutdown_rx.recv() => return,
    }
  }
}
