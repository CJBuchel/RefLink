// This is a generated file - do not edit.
//
// Generated from api.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'api.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'api.pbenum.dart';

class RefereeStreamRequest extends $pb.GeneratedMessage {
  factory RefereeStreamRequest({
    $core.int? panelId,
    RefereeVote? refereeVote,
  }) {
    final result = create();
    if (panelId != null) result.panelId = panelId;
    if (refereeVote != null) result.refereeVote = refereeVote;
    return result;
  }

  RefereeStreamRequest._();

  factory RefereeStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefereeStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefereeStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'panelId')
    ..aE<RefereeVote>(2, _omitFieldNames ? '' : 'refereeVote',
        enumValues: RefereeVote.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefereeStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefereeStreamRequest copyWith(void Function(RefereeStreamRequest) updates) =>
      super.copyWith((message) => updates(message as RefereeStreamRequest))
          as RefereeStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefereeStreamRequest create() => RefereeStreamRequest._();
  @$core.override
  RefereeStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefereeStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefereeStreamRequest>(create);
  static RefereeStreamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get panelId => $_getIZ(0);
  @$pb.TagNumber(1)
  set panelId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPanelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPanelId() => $_clearField(1);

  @$pb.TagNumber(2)
  RefereeVote get refereeVote => $_getN(1);
  @$pb.TagNumber(2)
  set refereeVote(RefereeVote value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRefereeVote() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefereeVote() => $_clearField(2);
}

class RefereeStreamResponse extends $pb.GeneratedMessage {
  factory RefereeStreamResponse({
    $core.int? matchId,
    MatchPhase? matchPhase,
  }) {
    final result = create();
    if (matchId != null) result.matchId = matchId;
    if (matchPhase != null) result.matchPhase = matchPhase;
    return result;
  }

  RefereeStreamResponse._();

  factory RefereeStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefereeStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefereeStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'matchId')
    ..aE<MatchPhase>(2, _omitFieldNames ? '' : 'matchPhase',
        enumValues: MatchPhase.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefereeStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefereeStreamResponse copyWith(
          void Function(RefereeStreamResponse) updates) =>
      super.copyWith((message) => updates(message as RefereeStreamResponse))
          as RefereeStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefereeStreamResponse create() => RefereeStreamResponse._();
  @$core.override
  RefereeStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefereeStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefereeStreamResponse>(create);
  static RefereeStreamResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get matchId => $_getIZ(0);
  @$pb.TagNumber(1)
  set matchId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  MatchPhase get matchPhase => $_getN(1);
  @$pb.TagNumber(2)
  set matchPhase(MatchPhase value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchPhase() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
