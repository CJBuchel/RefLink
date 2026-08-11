// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Mqtt)
final mqttProvider = MqttProvider._();

final class MqttProvider extends $NotifierProvider<Mqtt, MqttServerClient> {
  MqttProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mqttProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mqttHash();

  @$internal
  @override
  Mqtt create() => Mqtt();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MqttServerClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MqttServerClient>(value),
    );
  }
}

String _$mqttHash() => r'491d150f56eca8a10ccfa59a8d3a924390e936f0';

abstract class _$Mqtt extends $Notifier<MqttServerClient> {
  MqttServerClient build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MqttServerClient, MqttServerClient>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MqttServerClient, MqttServerClient>,
              MqttServerClient,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Replaces the old bespoke health-check stream entirely - the MQTT client's own
/// connect/disconnect state already is the "is the server reachable" signal, so there's
/// nothing app-specific left to check for.

@ProviderFor(mqttConnectionStatus)
final mqttConnectionStatusProvider = MqttConnectionStatusProvider._();

/// Replaces the old bespoke health-check stream entirely - the MQTT client's own
/// connect/disconnect state already is the "is the server reachable" signal, so there's
/// nothing app-specific left to check for.

final class MqttConnectionStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Replaces the old bespoke health-check stream entirely - the MQTT client's own
  /// connect/disconnect state already is the "is the server reachable" signal, so there's
  /// nothing app-specific left to check for.
  MqttConnectionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mqttConnectionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mqttConnectionStatusHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return mqttConnectionStatus(ref);
  }
}

String _$mqttConnectionStatusHash() =>
    r'2a1b7c8dcb69e5e043837f8bebae7e1ffca12bb6';
