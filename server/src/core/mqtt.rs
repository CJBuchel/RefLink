use std::time::Duration;

use anyhow::Result;
use once_cell::sync::OnceCell;
use prost::Message;
use rumqttc::{AsyncClient, MqttOptions, QoS};

use crate::core::events::{ChangeEvent, EVENT_BUS};

pub static MQTT: OnceCell<AsyncClient> = OnceCell::new();

pub const TOPIC_FMS_MATCH_INFO: &str = "reflink/fms/match-info";
pub const TOPIC_FMS_CONNECTION_STATUS: &str = "reflink/fms/connection-status";

pub struct MqttConfig {
  pub host: String,
  pub port: u16,
  pub username: Option<String>,
  pub password: Option<String>,
}

/// A raw incoming MQTT publish, before any route-specific decoding - see `init_mqtt` for why
/// this goes through `EVENT_BUS` instead of a bespoke dispatch mechanism.
#[derive(Clone, Debug)]
pub struct MqttInbound {
  pub topic: String,
  pub payload: Vec<u8>,
}

/// Connects to the broker, subscribes to `topics`, and starts the background task that pumps
/// the connection. Incoming publishes on any subscribed topic are re-published onto the
/// existing internal `EVENT_BUS` as `ChangeEvent::Message { topic, data: MqttInbound }` rather
/// than routed through some new per-topic dispatch table - every internal consumer already
/// knows how to subscribe to a bus type and filter by topic, so this reuses that instead of
/// inventing a second, parallel fan-out mechanism.
pub async fn init_mqtt(config: MqttConfig, topics: &[&str]) -> Result<()> {
  let mut options = MqttOptions::new("reflink-server", config.host, config.port);
  options.set_keep_alive(Duration::from_secs(5));

  if let (Some(username), Some(password)) = (config.username, config.password) {
    options.set_credentials(username, password);
  }

  let (client, mut eventloop) = AsyncClient::new(options, 256);

  for topic in topics {
    log::info!("[MQTT] Subscribing to {topic}");
    client.subscribe(*topic, QoS::AtLeastOnce).await?;
  }

  // rumqttc is push-driven: the eventloop must be polled continuously for anything - outgoing
  // publishes actually flushing, incoming acks, keepalive pings - to happen at all. Reconnects
  // on error are handled by rumqttc itself internally on the next `poll()`.
  tokio::spawn(async move {
    loop {
      match eventloop.poll().await {
        Ok(rumqttc::Event::Incoming(rumqttc::Packet::ConnAck(ack))) => {
          log::info!("[MQTT] Connected to broker ({ack:?})");
        }
        Ok(rumqttc::Event::Incoming(rumqttc::Packet::SubAck(ack))) => {
          log::info!("[MQTT] Subscription acknowledged ({ack:?})");
        }
        Ok(rumqttc::Event::Incoming(rumqttc::Packet::Publish(publish))) => {
          log::info!("[MQTT] Incoming publish: topic={} len={}", publish.topic, publish.payload.len());
          if let Some(bus) = EVENT_BUS.get() {
            let inbound = MqttInbound { topic: publish.topic, payload: publish.payload.to_vec() };
            let _ = bus.publish(ChangeEvent::Message { topic: inbound.topic.clone(), data: inbound });
          }
        }
        Ok(_) => {}
        Err(e) => {
          log::warn!("[MQTT] Connection error: {e}, retrying...");
          tokio::time::sleep(Duration::from_secs(1)).await;
        }
      }
    }
  });

  MQTT.set(client).map_err(|_| anyhow::anyhow!("MQTT client already initialized"))?;
  Ok(())
}

pub async fn publish<T: Message>(topic: &str, retain: bool, msg: &T) -> Result<()> {
  let client = MQTT.get().ok_or_else(|| anyhow::anyhow!("MQTT client not initialized"))?;
  client.publish(topic, QoS::AtLeastOnce, retain, msg.encode_to_vec()).await?;
  Ok(())
}
