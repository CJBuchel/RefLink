// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referee_panel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RefereePanelServer)
final refereePanelServerProvider = RefereePanelServerProvider._();

final class RefereePanelServerProvider
    extends $NotifierProvider<RefereePanelServer, HeadRefereeStreamResponse> {
  RefereePanelServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereePanelServerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereePanelServerHash();

  @$internal
  @override
  RefereePanelServer create() => RefereePanelServer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HeadRefereeStreamResponse value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HeadRefereeStreamResponse>(value),
    );
  }
}

String _$refereePanelServerHash() =>
    r'e3974d226f3b74c841de243782fd2bf8cc94a00b';

abstract class _$RefereePanelServer
    extends $Notifier<HeadRefereeStreamResponse> {
  HeadRefereeStreamResponse build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<HeadRefereeStreamResponse, HeadRefereeStreamResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HeadRefereeStreamResponse, HeadRefereeStreamResponse>,
              HeadRefereeStreamResponse,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RefereePanel)
final refereePanelProvider = RefereePanelProvider._();

final class RefereePanelProvider
    extends $NotifierProvider<RefereePanel, RefereeStreamRequest> {
  RefereePanelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereePanelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereePanelHash();

  @$internal
  @override
  RefereePanel create() => RefereePanel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefereeStreamRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefereeStreamRequest>(value),
    );
  }
}

String _$refereePanelHash() => r'a3a8e3634f4ec68c6766f464cb0b0236156fafa1';

abstract class _$RefereePanel extends $Notifier<RefereeStreamRequest> {
  RefereeStreamRequest build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RefereeStreamRequest, RefereeStreamRequest>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RefereeStreamRequest, RefereeStreamRequest>,
              RefereeStreamRequest,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RefereeSubtractionMode)
final refereeSubtractionModeProvider = RefereeSubtractionModeProvider._();

final class RefereeSubtractionModeProvider
    extends $NotifierProvider<RefereeSubtractionMode, bool> {
  RefereeSubtractionModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereeSubtractionModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereeSubtractionModeHash();

  @$internal
  @override
  RefereeSubtractionMode create() => RefereeSubtractionMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$refereeSubtractionModeHash() =>
    r'abcef832296499e83d35981b9e2327f94984ec98';

abstract class _$RefereeSubtractionMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RefereeCardMode)
final refereeCardModeProvider = RefereeCardModeProvider._();

final class RefereeCardModeProvider
    extends $NotifierProvider<RefereeCardMode, bool> {
  RefereeCardModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereeCardModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereeCardModeHash();

  @$internal
  @override
  RefereeCardMode create() => RefereeCardMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$refereeCardModeHash() => r'eb432c24878a09d8e2f9ebb6c95198d8711975c3';

abstract class _$RefereeCardMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RefereeEndgameMode)
final refereeEndgameModeProvider = RefereeEndgameModeProvider._();

final class RefereeEndgameModeProvider
    extends $NotifierProvider<RefereeEndgameMode, bool> {
  RefereeEndgameModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereeEndgameModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereeEndgameModeHash();

  @$internal
  @override
  RefereeEndgameMode create() => RefereeEndgameMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$refereeEndgameModeHash() =>
    r'b830f7fb0a431d67828b8c15ecdf71a37d80865a';

abstract class _$RefereeEndgameMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
