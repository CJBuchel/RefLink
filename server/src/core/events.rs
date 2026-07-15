use std::any::{Any, TypeId};

use anyhow::Result;
use dashmap::DashMap;
use once_cell::sync::OnceCell;
use tokio::sync::broadcast;

pub static EVENT_BUS: OnceCell<EventBus> = OnceCell::new();

pub fn init_event_bus(capacity: usize) -> Result<()> {
  EVENT_BUS.set(EventBus::new(capacity)).map_err(|_| anyhow::anyhow!("Event bus already initialized"))
}

#[derive(Clone, Debug)]
pub enum ChangeOperation {
  Create,
  Update,
  Delete,
}

#[derive(Clone, Debug)]
pub enum ChangeEvent<T> {
  /// A single record was created, updated or deleted.
  Record { operation: ChangeOperation, id: String, data: Option<T> },
  /// The whole table/collection should be considered invalidated.
  Table,
  /// A generic, topic-addressed message for events that aren't record mutations.
  Message { topic: String, data: T },
}

/// A type-keyed multi-channel broadcast bus: one broadcast channel is lazily created per
/// distinct event payload type `T`, so unrelated domains (e.g. FMS match info vs referee
/// panel state) don't need to share a single giant event enum.
pub struct EventBus {
  channels: DashMap<TypeId, Box<dyn Any + Send + Sync>>,
  capacity: usize,
}

impl EventBus {
  pub fn new(capacity: usize) -> Self {
    Self { channels: DashMap::new(), capacity }
  }

  pub fn publish<T: Clone + Send + Sync + 'static>(&self, event: ChangeEvent<T>) -> Result<()> {
    if let Some(sender_box) = self.channels.get(&TypeId::of::<T>())
      && let Some(sender) = sender_box.downcast_ref::<broadcast::Sender<ChangeEvent<T>>>()
    {
      // Ignored if there are currently no subscribers.
      let _ = sender.send(event);
    }

    Ok(())
  }

  pub fn subscribe<T: Clone + Send + Sync + 'static>(&self) -> Result<broadcast::Receiver<ChangeEvent<T>>> {
    let sender_box = self.channels.entry(TypeId::of::<T>()).or_insert_with(|| {
      let (tx, _rx) = broadcast::channel::<ChangeEvent<T>>(self.capacity);
      Box::new(tx) as Box<dyn Any + Send + Sync>
    });

    let sender = sender_box
      .downcast_ref::<broadcast::Sender<ChangeEvent<T>>>()
      .ok_or_else(|| anyhow::anyhow!("Event bus channel type mismatch"))?;

    Ok(sender.subscribe())
  }
}
