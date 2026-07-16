use dashmap::DashSet;
use once_cell::sync::Lazy;

use crate::{
  core::events::{ChangeEvent, EVENT_BUS},
  generated::{api::PanelPresence, common::PanelType},
};

// Tracks which of the four regular referee panels currently have a live `RefereeStream`
// connection open - purely internal to RefLink (unrelated to Cheesy Arena), used to show the
// head referee a live connected/disconnected indicator for each panel.
static CONNECTED_PANELS: Lazy<DashSet<i32>> = Lazy::new(DashSet::new);

pub fn snapshot() -> PanelPresence {
  PanelPresence {
    rn: CONNECTED_PANELS.contains(&(PanelType::RedNear as i32)),
    rf: CONNECTED_PANELS.contains(&(PanelType::RedFar as i32)),
    bn: CONNECTED_PANELS.contains(&(PanelType::BlueNear as i32)),
    bf: CONNECTED_PANELS.contains(&(PanelType::BlueFar as i32)),
  }
}

fn publish() {
  if let Some(bus) = EVENT_BUS.get() {
    let _ = bus.publish(ChangeEvent::Message { topic: "presence".to_string(), data: snapshot() });
  }
}

pub fn mark_connected(panel: PanelType) {
  if matches!(panel, PanelType::RedNear | PanelType::RedFar | PanelType::BlueNear | PanelType::BlueFar) {
    CONNECTED_PANELS.insert(panel as i32);
    publish();
  }
}

pub fn mark_disconnected(panel: PanelType) {
  if matches!(panel, PanelType::RedNear | PanelType::RedFar | PanelType::BlueNear | PanelType::BlueFar) {
    CONNECTED_PANELS.remove(&(panel as i32));
    publish();
  }
}
