// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PanelId)
final panelIdProvider = PanelIdProvider._();

final class PanelIdProvider extends $NotifierProvider<PanelId, String> {
  PanelIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panelIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panelIdHash();

  @$internal
  @override
  PanelId create() => PanelId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$panelIdHash() => r'31388c9974f2781329fd2a7848348b8eb0107333';

abstract class _$PanelId extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(panelName)
final panelNameProvider = PanelNameProvider._();

final class PanelNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  PanelNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panelNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panelNameHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return panelName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$panelNameHash() => r'a4ecd8a08ad5025eb2a13cca884a9ba76813bdeb';
