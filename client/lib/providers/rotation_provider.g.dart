// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Matches remaining until rotation (0 = rotate now) - sourced from whichever server stream
/// is relevant to the currently active panel, so callers don't need to know which one to
/// watch. Callers derive whether/when to notify from this rather than a separate boolean.

@ProviderFor(rotationStatus)
final rotationStatusProvider = RotationStatusProvider._();

/// Matches remaining until rotation (0 = rotate now) - sourced from whichever server stream
/// is relevant to the currently active panel, so callers don't need to know which one to
/// watch. Callers derive whether/when to notify from this rather than a separate boolean.

final class RotationStatusProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Matches remaining until rotation (0 = rotate now) - sourced from whichever server stream
  /// is relevant to the currently active panel, so callers don't need to know which one to
  /// watch. Callers derive whether/when to notify from this rather than a separate boolean.
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return rotationStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$rotationStatusHash() => r'4676adec8b289dc5dc969849e74ed0d8f75ac8b9';
