// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fms_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fmsService)
final fmsServiceProvider = FmsServiceProvider._();

final class FmsServiceProvider
    extends
        $FunctionalProvider<
          FmsServiceClient,
          FmsServiceClient,
          FmsServiceClient
        >
    with $Provider<FmsServiceClient> {
  FmsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fmsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fmsServiceHash();

  @$internal
  @override
  $ProviderElement<FmsServiceClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FmsServiceClient create(Ref ref) {
    return fmsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FmsServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FmsServiceClient>(value),
    );
  }
}

String _$fmsServiceHash() => r'f63ca9161cd953fee11dc4dd4a9fd60a323c2a38';

@ProviderFor(arenaMatchInfo)
final arenaMatchInfoProvider = ArenaMatchInfoProvider._();

final class ArenaMatchInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<FmsMatchInfo>,
          FmsMatchInfo,
          Stream<FmsMatchInfo>
        >
    with $FutureModifier<FmsMatchInfo>, $StreamProvider<FmsMatchInfo> {
  ArenaMatchInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'arenaMatchInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$arenaMatchInfoHash();

  @$internal
  @override
  $StreamProviderElement<FmsMatchInfo> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<FmsMatchInfo> create(Ref ref) {
    return arenaMatchInfo(ref);
  }
}

String _$arenaMatchInfoHash() => r'051d1231a0f887b928753f8d6b7515a1f2efdd0a';
