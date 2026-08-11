use std::{
  any::{Any, TypeId},
  future::Future,
  sync::Mutex,
  time::Duration,
};

use anyhow::Result;
use dashmap::DashMap;
use once_cell::sync::OnceCell;
use tokio::sync::mpsc;
use tokio_stream::{Stream, StreamExt};

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

/// Shared cadence for every server-push route's `with_heartbeat` call - one constant so every
/// route stays consistent, and every client-side watchdog timeout can be defined relative to
/// it instead of each guessing its own number.
pub const HEARTBEAT_INTERVAL: Duration = Duration::from_secs(2);

/// Wraps any event-driven stream so it also emits at least once every `interval`, even if
/// `source` stays silent - the point isn't the data (a client already has it), it's that a
/// gap in receiving *anything* is what a client-side watchdog needs to detect a connection
/// that's gone quiet without either side seeing an error, and force a reconnect (see
/// `ReconnectingBidirectionalStream`/`ReconnectingStream` client-side). `EventBus` above only
/// guarantees an event queued for a subscriber is never dropped inside this process - it can't
/// guarantee the network stream carrying it to a specific client is actually still flowing.
/// Every server-push route gets this same guarantee by composing through here instead of
/// hand-rolling a reconcile tick per route, so a future route gets it for free too.
///
/// `resync` re-derives the current value from source of truth (not from replaying missed
/// events), so a periodic tick is still correct even if every prior event on `source` was
/// somehow missed. Also de-duplicates consecutive identical values from `source` itself, so
/// callers can yield a fresh candidate on every relevant event without checking themselves
/// whether it actually changed - only genuine changes and heartbeat ticks reach the client.
pub fn with_heartbeat<S, T, F, Fut>(source: S, interval: Duration, resync: F) -> impl Stream<Item = T>
where
  S: Stream<Item = T> + Send + 'static,
  T: Clone + PartialEq + Send + 'static,
  F: Fn() -> Fut + Send + 'static,
  Fut: Future<Output = T> + Send,
{
  async_stream::stream! {
    tokio::pin!(source);

    let mut ticker = tokio::time::interval(interval);
    ticker.tick().await; // fires immediately - source's own first item covers t=0, not this

    let mut last: Option<T> = None;

    loop {
      tokio::select! {
        item = source.next() => {
          match item {
            Some(value) => {
              let changed = last.as_ref() != Some(&value);
              last = Some(value.clone());
              if changed {
                yield value;
              }
            }
            None => break,
          }
        }
        _ = ticker.tick() => {
          let value = resync().await;
          last = Some(value.clone());
          yield value;
        }
      }
    }
  }
}
