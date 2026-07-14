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

import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pb.dart';

class GetHealthRequest extends $pb.GeneratedMessage {
  factory GetHealthRequest() => create();

  GetHealthRequest._();

  factory GetHealthRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHealthRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthRequest copyWith(void Function(GetHealthRequest) updates) =>
      super.copyWith((message) => updates(message as GetHealthRequest))
          as GetHealthRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHealthRequest create() => GetHealthRequest._();
  @$core.override
  GetHealthRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHealthRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthRequest>(create);
  static GetHealthRequest? _defaultInstance;
}

class GetHealthResponse extends $pb.GeneratedMessage {
  factory GetHealthResponse() => create();

  GetHealthResponse._();

  factory GetHealthResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHealthResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthResponse copyWith(void Function(GetHealthResponse) updates) =>
      super.copyWith((message) => updates(message as GetHealthResponse))
          as GetHealthResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHealthResponse create() => GetHealthResponse._();
  @$core.override
  GetHealthResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHealthResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthResponse>(create);
  static GetHealthResponse? _defaultInstance;
}

class RefereeStreamRequest extends $pb.GeneratedMessage {
  factory RefereeStreamRequest({
    $1.PanelType? panel,
    $core.int? matchId,
    $1.RefereePanelState? state,
  }) {
    final result = create();
    if (panel != null) result.panel = panel;
    if (matchId != null) result.matchId = matchId;
    if (state != null) result.state = state;
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
    ..aE<$1.PanelType>(1, _omitFieldNames ? '' : 'panel',
        enumValues: $1.PanelType.values)
    ..aI(2, _omitFieldNames ? '' : 'matchId')
    ..aOM<$1.RefereePanelState>(3, _omitFieldNames ? '' : 'state',
        subBuilder: $1.RefereePanelState.create)
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
  $1.PanelType get panel => $_getN(0);
  @$pb.TagNumber(1)
  set panel($1.PanelType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPanel() => $_has(0);
  @$pb.TagNumber(1)
  void clearPanel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get matchId => $_getIZ(1);
  @$pb.TagNumber(2)
  set matchId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.RefereePanelState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state($1.RefereePanelState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.RefereePanelState ensureState() => $_ensure(2);
}

class RefereeStreamResponse extends $pb.GeneratedMessage {
  factory RefereeStreamResponse({
    $core.int? matchId,
    $1.MatchPhase? matchPhase,
    $core.String? allianceStation1TeamNumber,
    $core.String? allianceStation2TeamNumber,
    $core.String? allianceStation3TeamNumber,
    $1.RefereePanelState? partnerPanel,
  }) {
    final result = create();
    if (matchId != null) result.matchId = matchId;
    if (matchPhase != null) result.matchPhase = matchPhase;
    if (allianceStation1TeamNumber != null)
      result.allianceStation1TeamNumber = allianceStation1TeamNumber;
    if (allianceStation2TeamNumber != null)
      result.allianceStation2TeamNumber = allianceStation2TeamNumber;
    if (allianceStation3TeamNumber != null)
      result.allianceStation3TeamNumber = allianceStation3TeamNumber;
    if (partnerPanel != null) result.partnerPanel = partnerPanel;
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
    ..aE<$1.MatchPhase>(2, _omitFieldNames ? '' : 'matchPhase',
        enumValues: $1.MatchPhase.values)
    ..aOS(3, _omitFieldNames ? '' : 'allianceStation1TeamNumber',
        protoName: 'alliance_station_1_team_number')
    ..aOS(4, _omitFieldNames ? '' : 'allianceStation2TeamNumber',
        protoName: 'alliance_station_2_team_number')
    ..aOS(5, _omitFieldNames ? '' : 'allianceStation3TeamNumber',
        protoName: 'alliance_station_3_team_number')
    ..aOM<$1.RefereePanelState>(6, _omitFieldNames ? '' : 'partnerPanel',
        subBuilder: $1.RefereePanelState.create)
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
  $1.MatchPhase get matchPhase => $_getN(1);
  @$pb.TagNumber(2)
  set matchPhase($1.MatchPhase value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get allianceStation1TeamNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set allianceStation1TeamNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAllianceStation1TeamNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllianceStation1TeamNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get allianceStation2TeamNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set allianceStation2TeamNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAllianceStation2TeamNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllianceStation2TeamNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get allianceStation3TeamNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set allianceStation3TeamNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAllianceStation3TeamNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearAllianceStation3TeamNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.RefereePanelState get partnerPanel => $_getN(5);
  @$pb.TagNumber(6)
  set partnerPanel($1.RefereePanelState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPartnerPanel() => $_has(5);
  @$pb.TagNumber(6)
  void clearPartnerPanel() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.RefereePanelState ensurePartnerPanel() => $_ensure(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
