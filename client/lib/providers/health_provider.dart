import 'package:ref_link/providers/mqtt_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_provider.g.dart';

// The gRPC health-check stream is gone - the MQTT client's own connection state already is
// the "is the server reachable" signal (see mqtt_provider.dart's mqttConnectionStatusProvider).
// Kept as a thin wrapper under its old name so callers (e.g. the connected/disconnected banner
// in base/app_bar.dart) don't need to change.
@riverpod
Stream<bool> isConnected(Ref ref) {
  return mqttConnectionStatusStream(ref.watch(mqttProvider));
}
