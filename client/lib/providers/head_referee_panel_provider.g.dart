// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'head_referee_panel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(headRefereePanelService)
final headRefereePanelServiceProvider = HeadRefereePanelServiceProvider._();

final class HeadRefereePanelServiceProvider
    extends
        $FunctionalProvider<
          HeadRefereePanelServiceClient,
          HeadRefereePanelServiceClient,
          HeadRefereePanelServiceClient
        >
    with $Provider<HeadRefereePanelServiceClient> {
  HeadRefereePanelServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'headRefereePanelServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$headRefereePanelServiceHash();

  @$internal
  @override
  $ProviderElement<HeadRefereePanelServiceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HeadRefereePanelServiceClient create(Ref ref) {
    return headRefereePanelService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HeadRefereePanelServiceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HeadRefereePanelServiceClient>(
        value,
      ),
    );
  }
}

String _$headRefereePanelServiceHash() =>
    r'979709bcef2381e48680210ef5849c5eee0773bf';

@ProviderFor(headRefereePanelConnection)
final headRefereePanelConnectionProvider =
    HeadRefereePanelConnectionProvider._();

final class HeadRefereePanelConnectionProvider
    extends
        $FunctionalProvider<
          ReconnectingBidirectionalStream<
            HeadRefereeStreamRequest,
            HeadRefereeStreamResponse
          >,
          ReconnectingBidirectionalStream<
            HeadRefereeStreamRequest,
            HeadRefereeStreamResponse
          >,
          ReconnectingBidirectionalStream<
            HeadRefereeStreamRequest,
            HeadRefereeStreamResponse
          >
        >
    with
        $Provider<
          ReconnectingBidirectionalStream<
            HeadRefereeStreamRequest,
            HeadRefereeStreamResponse
          >
        > {
  HeadRefereePanelConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'headRefereePanelConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$headRefereePanelConnectionHash();

  @$internal
  @override
  $ProviderElement<
    ReconnectingBidirectionalStream<
      HeadRefereeStreamRequest,
      HeadRefereeStreamResponse
    >
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ReconnectingBidirectionalStream<
    HeadRefereeStreamRequest,
    HeadRefereeStreamResponse
  >
  create(Ref ref) {
    return headRefereePanelConnection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    ReconnectingBidirectionalStream<
      HeadRefereeStreamRequest,
      HeadRefereeStreamResponse
    >
    value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            ReconnectingBidirectionalStream<
              HeadRefereeStreamRequest,
              HeadRefereeStreamResponse
            >
          >(value),
    );
  }
}

String _$headRefereePanelConnectionHash() =>
    r'55882ec0eacab2d7b8019cde8184f3b8f555334b';

@ProviderFor(HeadRefereePanelServer)
final headRefereePanelServerProvider = HeadRefereePanelServerProvider._();

final class HeadRefereePanelServerProvider
    extends
        $NotifierProvider<HeadRefereePanelServer, HeadRefereeStreamResponse> {
  HeadRefereePanelServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'headRefereePanelServerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$headRefereePanelServerHash();

  @$internal
  @override
  HeadRefereePanelServer create() => HeadRefereePanelServer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HeadRefereeStreamResponse value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HeadRefereeStreamResponse>(value),
    );
  }
}

String _$headRefereePanelServerHash() =>
    r'bcbc60fb17bc395d57fbc56cf58fc1efe0f5907f';

abstract class _$HeadRefereePanelServer
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

@ProviderFor(HeadRefereePanel)
final headRefereePanelProvider = HeadRefereePanelProvider._();

final class HeadRefereePanelProvider
    extends $NotifierProvider<HeadRefereePanel, HeadRefereeStreamRequest> {
  HeadRefereePanelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'headRefereePanelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$headRefereePanelHash();

  @$internal
  @override
  HeadRefereePanel create() => HeadRefereePanel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HeadRefereeStreamRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HeadRefereeStreamRequest>(value),
    );
  }
}

String _$headRefereePanelHash() => r'4e2c45f239e35cce44fd45e01581e276fb7b1b72';

abstract class _$HeadRefereePanel extends $Notifier<HeadRefereeStreamRequest> {
  HeadRefereeStreamRequest build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<HeadRefereeStreamRequest, HeadRefereeStreamRequest>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HeadRefereeStreamRequest, HeadRefereeStreamRequest>,
              HeadRefereeStreamRequest,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
