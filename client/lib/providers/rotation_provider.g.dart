// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// (shouldRotate, matchesUntilRotation) - sourced from whichever server stream is relevant
/// to the currently active panel, so callers don't need to know which one to watch.

@ProviderFor(rotationStatus)
final rotationStatusProvider = RotationStatusProvider._();

/// (shouldRotate, matchesUntilRotation) - sourced from whichever server stream is relevant
/// to the currently active panel, so callers don't need to know which one to watch.

final class RotationStatusProvider
    extends $FunctionalProvider<(bool, int), (bool, int), (bool, int)>
    with $Provider<(bool, int)> {
  /// (shouldRotate, matchesUntilRotation) - sourced from whichever server stream is relevant
  /// to the currently active panel, so callers don't need to know which one to watch.
  RotationStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rotationStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rotationStatusHash();

  @$internal
  @override
  $ProviderElement<(bool, int)> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  (bool, int) create(Ref ref) {
    return rotationStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((bool, int) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(bool, int)>(value),
    );
  }
}

String _$rotationStatusHash() => r'2f2c0d8cbdd8beab3da99269a795241e54155c78';
