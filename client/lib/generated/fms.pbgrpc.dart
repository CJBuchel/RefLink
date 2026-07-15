// This is a generated file - do not edit.
//
// Generated from fms.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'fms.pb.dart' as $0;

export 'fms.pb.dart';

@$pb.GrpcServiceName('reflink.fms.FmsService')
class FmsServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  FmsServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.FmsMatchInfo> getMatchInfo(
    $0.GetMatchInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMatchInfo, request, options: options);
  }

  $grpc.ResponseStream<$0.FmsMatchInfo> streamMatchInfo(
    $0.StreamMatchInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$streamMatchInfo, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.FmsConnectionStatus> streamConnectionStatus(
    $0.StreamConnectionStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$streamConnectionStatus, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$getMatchInfo =
      $grpc.ClientMethod<$0.GetMatchInfoRequest, $0.FmsMatchInfo>(
          '/reflink.fms.FmsService/GetMatchInfo',
          ($0.GetMatchInfoRequest value) => value.writeToBuffer(),
          $0.FmsMatchInfo.fromBuffer);
  static final _$streamMatchInfo =
      $grpc.ClientMethod<$0.StreamMatchInfoRequest, $0.FmsMatchInfo>(
          '/reflink.fms.FmsService/StreamMatchInfo',
          ($0.StreamMatchInfoRequest value) => value.writeToBuffer(),
          $0.FmsMatchInfo.fromBuffer);
  static final _$streamConnectionStatus = $grpc.ClientMethod<
          $0.StreamConnectionStatusRequest, $0.FmsConnectionStatus>(
      '/reflink.fms.FmsService/StreamConnectionStatus',
      ($0.StreamConnectionStatusRequest value) => value.writeToBuffer(),
      $0.FmsConnectionStatus.fromBuffer);
}

@$pb.GrpcServiceName('reflink.fms.FmsService')
abstract class FmsServiceBase extends $grpc.Service {
  $core.String get $name => 'reflink.fms.FmsService';

  FmsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetMatchInfoRequest, $0.FmsMatchInfo>(
        'GetMatchInfo',
        getMatchInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMatchInfoRequest.fromBuffer(value),
        ($0.FmsMatchInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamMatchInfoRequest, $0.FmsMatchInfo>(
        'StreamMatchInfo',
        streamMatchInfo_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.StreamMatchInfoRequest.fromBuffer(value),
        ($0.FmsMatchInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamConnectionStatusRequest,
            $0.FmsConnectionStatus>(
        'StreamConnectionStatus',
        streamConnectionStatus_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.StreamConnectionStatusRequest.fromBuffer(value),
        ($0.FmsConnectionStatus value) => value.writeToBuffer()));
  }

  $async.Future<$0.FmsMatchInfo> getMatchInfo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMatchInfoRequest> $request) async {
    return getMatchInfo($call, await $request);
  }

  $async.Future<$0.FmsMatchInfo> getMatchInfo(
      $grpc.ServiceCall call, $0.GetMatchInfoRequest request);

  $async.Stream<$0.FmsMatchInfo> streamMatchInfo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StreamMatchInfoRequest> $request) async* {
    yield* streamMatchInfo($call, await $request);
  }

  $async.Stream<$0.FmsMatchInfo> streamMatchInfo(
      $grpc.ServiceCall call, $0.StreamMatchInfoRequest request);

  $async.Stream<$0.FmsConnectionStatus> streamConnectionStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StreamConnectionStatusRequest> $request) async* {
    yield* streamConnectionStatus($call, await $request);
  }

  $async.Stream<$0.FmsConnectionStatus> streamConnectionStatus(
      $grpc.ServiceCall call, $0.StreamConnectionStatusRequest request);
}
