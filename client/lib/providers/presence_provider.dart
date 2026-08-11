import 'package:mqtt_client/mqtt_client.dart';
import 'package:ref_link/providers/mqtt_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'presence_provider.g.dart';

/// Whether each of the four regular referee panels currently has a live connection to the
/// broker - a plain Dart class now, not a protobuf message, since this is derived entirely
/// client-side from broker-native LWT/retained presence topics (see mqtt_provider.dart);
/// there's no server-side presence computation to mirror any more.
class PanelPresence {
  final bool rn;
  final bool rf;
  final bool bn;
  final bool bf;

  const PanelPresence({this.rn = false, this.rf = false, this.bn = false, this.bf = false});

  PanelPresence copyWith({bool? rn, bool? rf, bool? bn, bool? bf}) =>
      PanelPresence(rn: rn ?? this.rn, rf: rf ?? this.rf, bn: bn ?? this.bn, bf: bf ?? this.bf);
}

@Riverpod(keepAlive: true)
class RefereePanelPresence extends _$RefereePanelPresence {
  @override
  PanelPresence build() {
    final client = ref.watch(mqttProvider);
    client.subscribe(presenceTopicWildcard, MqttQos.atLeastOnce);

    final subscription = client.updates!
        .expand((event) => event)
        .where((msg) => msg.topic.startsWith('reflink/referee-panel/') && msg.topic.endsWith('/presence'))
        .listen((msg) {
          final publish = msg.payload as MqttPublishMessage;
          final connected = MqttPublishPayload.bytesToStringAsString(publish.payload.message) == 'true';
          // reflink/referee-panel/{slug}/presence
          final slug = msg.topic.split('/')[2];

          switch (slug) {
            case 'red-near':
              state = state.copyWith(rn: connected);
            case 'red-far':
              state = state.copyWith(rf: connected);
            case 'blue-near':
              state = state.copyWith(bn: connected);
            case 'blue-far':
              state = state.copyWith(bf: connected);
          }
        });
    ref.onDispose(subscription.cancel);

    return const PanelPresence();
  }
}
