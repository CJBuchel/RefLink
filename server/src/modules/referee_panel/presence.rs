use dashmap::DashMap;
use once_cell::sync::Lazy;

use crate::{
  core::events::{ChangeEvent, EVENT_BUS},
  generated::{api::PanelPresence, common::PanelType},
};

// Tracks how many live `RefereeStream` connections currently claim each of the four regular
// referee panels - purely internal to RefLink (unrelated to Cheesy Arena), used to show the
// head referee a live connected/disconnected indicator for each panel.
//
// A count, not a set: each `RefereeStream` call runs its own independent task, and a client
// reconnect (e.g. after a network drop) opens a new one before the old one has necessarily
// noticed its connection is dead. If presence were a plain "is this panel type present" set,
// the old connection's belated disconnect could fire after the new connection's connect and
// incorrectly clear presence for a panel that's actually still connected.
static CONNECTED_PANELS: Lazy<DashMap<i32, u32>> = Lazy::new(DashMap::new);

fn is_connected(panel: PanelType) -> bool {
  CONNECTED_PANELS.get(&(panel as i32)).is_some_and(|count| *count > 0)
}

pub fn snapshot() -> PanelPresence {
  PanelPresence {
    rn: is_connected(PanelType::RedNear),
    rf: is_connected(PanelType::RedFar),
    bn: is_connected(PanelType::BlueNear),
    bf: is_connected(PanelType::BlueFar),
  }
}

fn publish() {
  if let Some(bus) = EVENT_BUS.get() {
    let _ = bus.publish(ChangeEvent::Message { topic: "presence".to_string(), data: snapshot() });
  }
}

pub fn mark_connected(panel: PanelType) {
  if matches!(panel, PanelType::RedNear | PanelType::RedFar | PanelType::BlueNear | PanelType::BlueFar) {
    *CONNECTED_PANELS.entry(panel as i32).or_insert(0) += 1;
    publish();
  }
}

pub fn mark_disconnected(panel: PanelType) {
  if matches!(panel, PanelType::RedNear | PanelType::RedFar | PanelType::BlueNear | PanelType::BlueFar)
    && let Some(mut count) = CONNECTED_PANELS.get_mut(&(panel as i32))
  {
    *count = count.saturating_sub(1);
    drop(count);
    publish();
  }
}
