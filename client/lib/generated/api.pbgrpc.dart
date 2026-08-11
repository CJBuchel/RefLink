// This is a generated file - do not edit.
//
// Generated from api.proto.

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

import 'api.pb.dart' as $0;

export 'api.pb.dart';

@$pb.GrpcServiceName('reflink.api.HeadRefereePanelService')
class HeadRefereePanelServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HeadRefereePanelServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ToggleBypassResponse> toggleBypass(
    $0.ToggleBypassRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$toggleBypass, request, options: options);
  }

  $grpc.ResponseFuture<$0.CommitAndPostResponse> commitAndPost(
    $0.CommitAndPostRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$commitAndPost, request, options: options);
  }

  // method descriptors

  static final _$toggleBypass =
      $grpc.ClientMethod<$0.ToggleBypassRequest, $0.ToggleBypassResponse>(
          '/reflink.api.HeadRefereePanelService/ToggleBypass',
          ($0.ToggleBypassRequest value) => value.writeToBuffer(),
          $0.ToggleBypassResponse.fromBuffer);
  static final _$commitAndPost =
      $grpc.ClientMethod<$0.CommitAndPostRequest, $0.CommitAndPostResponse>(
          '/reflink.api.HeadRefereePanelService/CommitAndPost',
          ($0.CommitAndPostRequest value) => value.writeToBuffer(),
          $0.CommitAndPostResponse.fromBuffer);
}

@$pb.GrpcServiceName('reflink.api.HeadRefereePanelService')
abstract class HeadRefereePanelServiceBase extends $grpc.Service {
  $core.String get $name => 'reflink.api.HeadRefereePanelService';

  HeadRefereePanelServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ToggleBypassRequest, $0.ToggleBypassResponse>(
            'ToggleBypass',
            toggleBypass_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ToggleBypassRequest.fromBuffer(value),
            ($0.ToggleBypassResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CommitAndPostRequest, $0.CommitAndPostResponse>(
            'CommitAndPost',
            commitAndPost_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CommitAndPostRequest.fromBuffer(value),
            ($0.CommitAndPostResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ToggleBypassResponse> toggleBypass_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ToggleBypassRequest> $request) async {
    return toggleBypass($call, await $request);
  }

  $async.Future<$0.ToggleBypassResponse> toggleBypass(
      $grpc.ServiceCall call, $0.ToggleBypassRequest request);

  $async.Future<$0.CommitAndPostResponse> commitAndPost_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CommitAndPostRequest> $request) async {
    return commitAndPost($call, await $request);
  }

  $async.Future<$0.CommitAndPostResponse> commitAndPost(
      $grpc.ServiceCall call, $0.CommitAndPostRequest request);
}
