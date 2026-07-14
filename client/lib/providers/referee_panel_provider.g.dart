// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referee_panel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(refereePanelService)
final refereePanelServiceProvider = RefereePanelServiceProvider._();

final class RefereePanelServiceProvider
    extends
        $FunctionalProvider<
          RefereePanelServiceClient,
          RefereePanelServiceClient,
          RefereePanelServiceClient
        >
    with $Provider<RefereePanelServiceClient> {
  RefereePanelServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereePanelServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereePanelServiceHash();

  @$internal
  @override
  $ProviderElement<RefereePanelServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefereePanelServiceClient create(Ref ref) {
    return refereePanelService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefereePanelServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefereePanelServiceClient>(value),
    );
  }
}

String _$refereePanelServiceHash() =>
    r'15e9a9c13d38580e156b503a88280218b6535c7c';

@ProviderFor(refereePanelConnection)
final refereePanelConnectionProvider = RefereePanelConnectionProvider._();

final class RefereePanelConnectionProvider
    extends
        $FunctionalProvider<
          ReconnectingBidirectionalStream<
            RefereeStreamRequest,
            RefereeStreamResponse
          >,
          ReconnectingBidirectionalStream<
            RefereeStreamRequest,
            RefereeStreamResponse
          >,
          ReconnectingBidirectionalStream<
            RefereeStreamRequest,
            RefereeStreamResponse
          >
        >
    with
        $Provider<
          ReconnectingBidirectionalStream<
            RefereeStreamRequest,
            RefereeStreamResponse
          >
        > {
  RefereePanelConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refereePanelConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refereePanelConnectionHash();

  @$internal
  @override
  $ProviderElement<
    ReconnectingBidirectionalStream<RefereeStreamRequest, RefereeStreamResponse>
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ReconnectingBidirectionalStream<RefereeStreamRequest, RefereeStreamResponse>
  create(Ref ref) {
    return refereePanelConnection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ReconnectingBidirectionalStream<RefereeStreamRequest, RefereeStreamResponse>
    value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ReconnectingBidirectionalStream<
              RefereeStreamRequest,
              RefereeStreamResponse
            >
          >(value),
    );
  }
}

String _$refereePanelConnectionHash() =>
    r'f8c8d4d5a8571e018d66c1079fb93366fa7e026b';

@ProviderFor(RefereePanelServer)
final refereePanelServerProvider = RefereePanelServerProvider._();

final class RefereePanelServerProvider
    extends $NotifierProvider<RefereePanelServer, RefereeStreamResponse> {
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
  Override overrideWithValue(RefereeStreamResponse value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefereeStreamResponse>(value),
    );
  }
}

String _$refereePanelServerHash() =>
    r'eec6a5ea9a73d609f0c3eadbee032f825e454182';

abstract class _$RefereePanelServer extends $Notifier<RefereeStreamResponse> {
  RefereeStreamResponse build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RefereeStreamResponse, RefereeStreamResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RefereeStreamResponse, RefereeStreamResponse>,
              RefereeStreamResponse,
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

String _$refereePanelHash() => r'04dc9a7f8888807a313777d8058e7c3a885326fd';

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
