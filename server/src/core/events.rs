use std::{
  any::{Any, TypeId},
  sync::Mutex,
};

use anyhow::Result;
use dashmap::DashMap;
use once_cell::sync::OnceCell;
use tokio::sync::mpsc;

pub static EVENT_BUS: OnceCell<EventBus> = OnceCell::new();

pub fn init_event_bus() -> Result<()> {
  EVENT_BUS.set(EventBus::new()).map_err(|_| anyhow::anyhow!("Event bus already initialized"))
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

type Subscribers<T> = Mutex<Vec<mpsc::UnboundedSender<ChangeEvent<T>>>>;

/// A type-keyed fan-out event bus: one unbounded queue per subscriber, not one shared bounded
/// broadcast channel. A shared bounded channel means a single slow/busy consumer can force its
/// own old events to be evicted once the buffer fills (a "lagged" gap the consumer has no way
/// to fill back in), even though every other consumer was keeping up fine. Giving each
/// subscriber its own unbounded queue instead means every event published after it subscribes
/// is guaranteed to reach it, in order, queued for as long as it takes to actually read it -
/// there is no lagged/dropped state to handle. Event volume here is low-frequency, per-match
/// domain events (match state, presence, FMS info), not a high-throughput stream, so unbounded
/// queuing per subscriber is safe: a queue only grows if a subscriber's task has stalled or
/// leaked, which is itself a bug worth surfacing rather than silently masking via eviction.
pub struct EventBus {
  channels: DashMap<TypeId, Box<dyn Any + Send + Sync>>,
}

impl EventBus {
  pub fn new() -> Self {
    Self { channels: DashMap::new() }
  }

  pub fn publish<T: Clone + Send + Sync + 'static>(&self, event: ChangeEvent<T>) -> Result<()> {
    // Must create the channel entry here too (not just in `subscribe`) - otherwise a publish
    // that happens to be the first-ever touch of type `T` (no subscriber has called
    // `subscribe::<T>` yet) would silently no-op instead of at least registering the channel
    // for whoever subscribes next.
    let entry = self
      .channels
      .entry(TypeId::of::<T>())
      .or_insert_with(|| Box::new(Subscribers::<T>::new(Vec::new())) as Box<dyn Any + Send + Sync>);

    if let Some(subscribers) = entry.downcast_ref::<Subscribers<T>>() {
      let mut senders = subscribers.lock().unwrap();
      // Prunes closed subscribers (dropped receivers, e.g. a client disconnected) as a side
      // effect of sending, so the list doesn't grow unbounded over the server's lifetime.
      senders.retain(|tx| tx.send(event.clone()).is_ok());
    }

    Ok(())
  }

  pub fn subscribe<T: Clone + Send + Sync + 'static>(&self) -> Result<mpsc::UnboundedReceiver<ChangeEvent<T>>> {
    let entry = self
      .channels
      .entry(TypeId::of::<T>())
      .or_insert_with(|| Box::new(Subscribers::<T>::new(Vec::new())) as Box<dyn Any + Send + Sync>);

    let subscribers = entry
      .downcast_ref::<Subscribers<T>>()
      .ok_or_else(|| anyhow::anyhow!("Event bus channel type mismatch"))?;

    let (tx, rx) = mpsc::unbounded_channel();
    subscribers.lock().unwrap().push(tx);
    Ok(rx)
  }
}
