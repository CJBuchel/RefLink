import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:protobuf/protobuf.dart';
import 'package:ref_link/generated/db.pbenum.dart';
import 'package:ref_link/models/panel_types.dart';
import 'package:ref_link/providers/network_config_provider.dart';
import 'package:ref_link/providers/panel_id_provider.dart';
import 'package:ref_link/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:typed_data/typed_data.dart' as typed;

part 'mqtt_provider.g.dart';

/// Referee panel slug used in every `reflink/referee-panel/{slug}/...` topic - mirrors
/// `panel_slug()` server-side (server/src/modules/sync.rs). Null for HR/unspecified, which have
/// no per-panel topics of their own.
String? panelSlug(PanelType panel) {
  switch (panel) {
    case PanelType.PANEL_TYPE_RED_NEAR:
      return 'red-near';
    case PanelType.PANEL_TYPE_RED_FAR:
      return 'red-far';
    case PanelType.PANEL_TYPE_BLUE_NEAR:
      return 'blue-near';
    case PanelType.PANEL_TYPE_BLUE_FAR:
      return 'blue-far';
    default:
      return null;
  }
}

String? submitTopicFor(PanelType panel) {
  final slug = panelSlug(panel);
  return slug == null ? null : 'reflink/referee-panel/$slug/submit';
}

String? presenceTopicFor(PanelType panel) {
  final slug = panelSlug(panel);
  return slug == null ? null : 'reflink/referee-panel/$slug/presence';
}

const presenceTopicWildcard = 'reflink/referee-panel/+/presence';
const matchStateTopic = 'reflink/match/state';
const headRefereeSubmitTopic = 'reflink/head-referee/submit';
const fmsMatchInfoTopic = 'reflink/fms/match-info';
const fmsConnectionStatusTopic = 'reflink/fms/connection-status';

extension MqttPublishing on MqttServerClient {
  /// Publishes a protobuf message, encoded exactly as the old gRPC framing did - only the
  /// transport changed, not the message shape (see server/src/modules/sync.rs).
  void publishProto(String topic, GeneratedMessage message, {bool retain = false}) {
    _publishBytes(topic, message.writeToBuffer(), retain: retain);
  }

  /// Publishes a plain string - used only for presence (`"true"`/`"false"`), which isn't part
  /// of the protobuf schema at all; it's a broker-native LWT-backed marker (see mqttProvider).
  void publishString(String topic, String value, {bool retain = false}) {
    _publishBytes(topic, value.codeUnits, retain: retain);
  }

  void _publishBytes(String topic, List<int> bytes, {bool retain = false}) {
    if (connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }
    final buffer = typed.Uint8Buffer()..addAll(bytes);
    publishMessage(topic, MqttQos.atLeastOnce, buffer, retain: retain);
  }
}

/// Every subscribed topic's messages arrive on the client's single shared `updates` stream -
/// this filters it down to one topic and decodes each payload, subscribing to the topic as a
/// side effect. Multiple callers filtering the same broadcast stream independently is fine
/// (standard Dart broadcast stream semantics), so each provider just calls this for whatever
/// topic it cares about instead of a bespoke per-topic dispatch mechanism.
Stream<T> subscribeDecoded<T extends GeneratedMessage>(
  MqttServerClient client,
  String topic,
  T Function(List<int>) fromBuffer,
) {
  client.subscribe(topic, MqttQos.atLeastOnce);

  return client.updates!.expand((event) => event).where((msg) => msg.topic == topic).map((msg) {
    final publish = msg.payload as MqttPublishMessage;
    return fromBuffer(publish.payload.message);
  });
}

// Owned at module level (not inside the notifier) since `MqttServerClient` only allows one
// callback per slot - the connect/disconnect/auto-reconnect callbacks set in `Mqtt.build()`
// below push into this broadcast controller instead of `health_provider.dart` (or anything
// else that wants connection status) trying to install its own competing callback and silently
// clobbering the presence-announcement logic that already lives there.
final _connectionStateController = StreamController<bool>.broadcast();

@Riverpod(keepAlive: true)
class Mqtt extends _$Mqtt {
  @override
  MqttServerClient build() {
    final host = ref.watch(serverIpProvider);
    final port = ref.watch(mqttPortProvider);
    final panelType = getPanelFromString(ref.watch(panelIdProvider));
    final presenceTopic = presenceTopicFor(panelType);

    final clientId = 'reflink-${DateTime.now().microsecondsSinceEpoch}';
    final client = MqttServerClient.withPort(host, clientId, port);
    client.logging(on: false);
    client.keepAlivePeriod = 5;
    client.autoReconnect = true;
    client.resubscribeOnAutoReconnect = true;
    client.setProtocolV311();

    final connectionMessage = MqttConnectMessage().withClientIdentifier(clientId).startClean();
    // Broker-native presence: fires automatically on an ungraceful disconnect, no server-side
    // bookkeeping needed at all (see server/src/modules/sync.rs's removal of presence.rs).
    if (presenceTopic != null) {
      connectionMessage
        ..withWillTopic(presenceTopic)
        ..withWillMessage('false')
        ..withWillQos(MqttQos.atLeastOnce)
        ..withWillRetain();
    }
    client.connectionMessage = connectionMessage;

    void announcePresence() {
      if (presenceTopic != null) {
        client.publishString(presenceTopic, 'true', retain: true);
      }
    }

    client.onConnected = () {
      logger.i('MQTT connected');
      announcePresence();
      _connectionStateController.add(true);
    };
    client.onAutoReconnected = () {
      logger.i('MQTT auto-reconnected');
      announcePresence();
      _connectionStateController.add(true);
    };
    client.onDisconnected = () {
      logger.w('MQTT disconnected');
      _connectionStateController.add(false);
    };

    client.connect().catchError((Object e) {
      logger.e('MQTT connect failed: $e');
      return null;
    });

    ref.onDispose(client.disconnect);

    return client;
  }
}

/// Replaces the old bespoke health-check stream entirely - the MQTT client's own
/// connect/disconnect state already is the "is the server reachable" signal, so there's
/// nothing app-specific left to check for. A plain function (not itself a provider) so both
/// `mqttConnectionStatusProvider` and health_provider.dart's `isConnected` can each watch
/// `mqttProvider` and build their own stream from it, rather than one provider awkwardly
/// reaching into another stream provider's internals.
Stream<bool> mqttConnectionStatusStream(MqttServerClient client) {
  return Stream.multi((controller) {
    controller.add(client.connectionStatus?.state == MqttConnectionState.connected);
    final subscription = _connectionStateController.stream.listen(controller.add);
    controller.onCancel = subscription.cancel;
  });
}

@riverpod
Stream<bool> mqttConnectionStatus(Ref ref) {
  return mqttConnectionStatusStream(ref.watch(mqttProvider));
}
