use std::collections::HashMap;

use crate::generated::{api::MatchStationState, fms::FmsMatchInfo};

fn team_number_string(n: i32) -> String {
  if n <= 0 { String::new() } else { n.to_string() }
}

/// Maps the FMS's current team lineup into `MatchStationState`s keyed by
/// `TeamAllianceStationType as i32`, shared by every panel-facing response builder
/// (`referee_panel`, `head_referee`).
pub fn map_teams(fms_info: &FmsMatchInfo) -> HashMap<i32, MatchStationState> {
  fms_info
    .teams
    .iter()
    .map(|t| {
      (
        t.alliance_station,
        MatchStationState {
          team_number: team_number_string(t.team_number),
          bypassed: t.bypassed,
          alliance_station: t.alliance_station,
        },
      )
    })
    .collect()
}
