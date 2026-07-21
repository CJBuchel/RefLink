mod client;
mod messages;
mod sync;

pub use client::{CheesyConfig, run};

use crate::generated::common::TeamAllianceStationType;

/// A fire-once "ask Cheesy Arena to flip this station's bypass" signal, published to the
/// event bus by `modules::head_referee::api` and relayed verbatim by `sync::run` - see
/// ToggleBypassRequest in api.proto for why this deliberately isn't part of any persisted
/// state.
#[derive(Clone)]
pub struct BypassToggleRequest {
  pub station: TeamAllianceStationType,
}

/// A fire-once "ask Cheesy Arena to commit and post the score" signal - see
/// CommitAndPostRequest in api.proto.
#[derive(Clone)]
pub struct CommitAndPostSignal;
