// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RefereePanelPresence)
final refereePanelPresenceProvider = RefereePanelPresenceProvider._();

final class RefereePanelPresenceProvider
    extends $NotifierProvider<RefereePanelPresence, PanelPresence> {
  RefereePanelPresenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereePanelPresenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereePanelPresenceHash();

  @$internal
  @override
  RefereePanelPresence create() => RefereePanelPresence();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanelPresence value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanelPresence>(value),
    );
  }
}

String _$refereePanelPresenceHash() =>
    r'03c663a5f020f8d99b43327b57785be9ee1d7bc8';

abstract class _$RefereePanelPresence extends $Notifier<PanelPresence> {
  PanelPresence build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PanelPresence, PanelPresence>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PanelPresence, PanelPresence>,
              PanelPresence,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
