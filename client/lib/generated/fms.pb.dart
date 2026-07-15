// This is a generated file - do not edit.
//
// Generated from fms.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pb.dart';

class FmsTeamState extends $pb.GeneratedMessage {
  factory FmsTeamState({
    $1.TeamAllianceStationType? allianceStation,
    $core.int? teamNumber,
    $core.bool? bypassed,
    $core.bool? estop,
    $core.bool? astop,
  }) {
    final result = create();
    if (allianceStation != null) result.allianceStation = allianceStation;
    if (teamNumber != null) result.teamNumber = teamNumber;
    if (bypassed != null) result.bypassed = bypassed;
    if (estop != null) result.estop = estop;
    if (astop != null) result.astop = astop;
    return result;
  }

  FmsTeamState._();

  factory FmsTeamState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FmsTeamState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FmsTeamState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.fms'),
      createEmptyInstance: create)
    ..aE<$1.TeamAllianceStationType>(
        1, _omitFieldNames ? '' : 'allianceStation',
        enumValues: $1.TeamAllianceStationType.values)
    ..aI(2, _omitFieldNames ? '' : 'teamNumber')
    ..aOB(3, _omitFieldNames ? '' : 'bypassed')
    ..aOB(4, _omitFieldNames ? '' : 'estop')
    ..aOB(5, _omitFieldNames ? '' : 'astop')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FmsTeamState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FmsTeamState copyWith(void Function(FmsTeamState) updates) =>
      super.copyWith((message) => updates(message as FmsTeamState))
          as FmsTeamState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FmsTeamState create() => FmsTeamState._();
  @$core.override
  FmsTeamState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FmsTeamState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FmsTeamState>(create);
  static FmsTeamState? _defaultInstance;

  @$pb.TagNumber(1)
  $1.TeamAllianceStationType get allianceStation => $_getN(0);
  @$pb.TagNumber(1)
  set allianceStation($1.TeamAllianceStationType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAllianceStation() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllianceStation() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get teamNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set teamNumber($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTeamNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearTeamNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get bypassed => $_getBF(2);
  @$pb.TagNumber(3)
  set bypassed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBypassed() => $_has(2);
  @$pb.TagNumber(3)
  void clearBypassed() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get estop => $_getBF(3);
  @$pb.TagNumber(4)
  set estop($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEstop() => $_has(3);
  @$pb.TagNumber(4)
  void clearEstop() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get astop => $_getBF(4);
  @$pb.TagNumber(5)
  set astop($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAstop() => $_has(4);
  @$pb.TagNumber(5)
  void clearAstop() => $_clearField(5);
}

class FmsMatchInfo extends $pb.GeneratedMessage {
  factory FmsMatchInfo({
    $core.int? matchId,
    $core.int? matchNumber,
    $1.MatchType? matchType,
    $1.MatchPhase? matchPhase,
    $core.int? timeRemainingSec,
    $core.Iterable<FmsTeamState>? teams,
  }) {
    final result = create();
    if (matchId != null) result.matchId = matchId;
    if (matchNumber != null) result.matchNumber = matchNumber;
    if (matchType != null) result.matchType = matchType;
    if (matchPhase != null) result.matchPhase = matchPhase;
    if (timeRemainingSec != null) result.timeRemainingSec = timeRemainingSec;
    if (teams != null) result.teams.addAll(teams);
    return result;
  }

  FmsMatchInfo._();

  factory FmsMatchInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FmsMatchInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FmsMatchInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.fms'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'matchId')
    ..aI(2, _omitFieldNames ? '' : 'matchNumber')
    ..aE<$1.MatchType>(3, _omitFieldNames ? '' : 'matchType',
        enumValues: $1.MatchType.values)
    ..aE<$1.MatchPhase>(4, _omitFieldNames ? '' : 'matchPhase',
        enumValues: $1.MatchPhase.values)
    ..aI(5, _omitFieldNames ? '' : 'timeRemainingSec')
    ..pPM<FmsTeamState>(6, _omitFieldNames ? '' : 'teams',
        subBuilder: FmsTeamState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FmsMatchInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FmsMatchInfo copyWith(void Function(FmsMatchInfo) updates) =>
      super.copyWith((message) => updates(message as FmsMatchInfo))
          as FmsMatchInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FmsMatchInfo create() => FmsMatchInfo._();
  @$core.override
  FmsMatchInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FmsMatchInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FmsMatchInfo>(create);
  static FmsMatchInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get matchId => $_getIZ(0);
  @$pb.TagNumber(1)
  set matchId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get matchNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set matchNumber($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.MatchType get matchType => $_getN(2);
  @$pb.TagNumber(3)
  set matchType($1.MatchType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMatchType() => $_has(2);
  @$pb.TagNumber(3)
  void clearMatchType() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.MatchPhase get matchPhase => $_getN(3);
  @$pb.TagNumber(4)
  set matchPhase($1.MatchPhase value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMatchPhase() => $_has(3);
  @$pb.TagNumber(4)
  void clearMatchPhase() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get timeRemainingSec => $_getIZ(4);
  @$pb.TagNumber(5)
  set timeRemainingSec($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimeRemainingSec() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimeRemainingSec() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<FmsTeamState> get teams => $_getList(5);
}

class FmsConnectionStatus extends $pb.GeneratedMessage {
  factory FmsConnectionStatus({
    $core.bool? connected,
    $core.String? host,
    $core.int? port,
    $core.String? lastError,
  }) {
    final result = create();
    if (connected != null) result.connected = connected;
    if (host != null) result.host = host;
    if (port != null) result.port = port;
    if (lastError != null) result.lastError = lastError;
    return result;
  }

  FmsConnectionStatus._();

  factory FmsConnectionStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FmsConnectionStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FmsConnectionStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.fms'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'connected')
    ..aOS(2, _omitFieldNames ? '' : 'host')
    ..aI(3, _omitFieldNames ? '' : 'port')
    ..aOS(4, _omitFieldNames ? '' : 'lastError')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FmsConnectionStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FmsConnectionStatus copyWith(void Function(FmsConnectionStatus) updates) =>
      super.copyWith((message) => updates(message as FmsConnectionStatus))
          as FmsConnectionStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FmsConnectionStatus create() => FmsConnectionStatus._();
  @$core.override
  FmsConnectionStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FmsConnectionStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FmsConnectionStatus>(create);
  static FmsConnectionStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get connected => $_getBF(0);
  @$pb.TagNumber(1)
  set connected($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConnected() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnected() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get host => $_getSZ(1);
  @$pb.TagNumber(2)
  set host($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHost() => $_has(1);
  @$pb.TagNumber(2)
  void clearHost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get port => $_getIZ(2);
  @$pb.TagNumber(3)
  set port($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearPort() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lastError => $_getSZ(3);
  @$pb.TagNumber(4)
  set lastError($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLastError() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastError() => $_clearField(4);
}

class GetMatchInfoRequest extends $pb.GeneratedMessage {
  factory GetMatchInfoRequest() => create();

  GetMatchInfoRequest._();

  factory GetMatchInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMatchInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMatchInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.fms'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMatchInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMatchInfoRequest copyWith(void Function(GetMatchInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetMatchInfoRequest))
          as GetMatchInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMatchInfoRequest create() => GetMatchInfoRequest._();
  @$core.override
  GetMatchInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMatchInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMatchInfoRequest>(create);
  static GetMatchInfoRequest? _defaultInstance;
}

class StreamMatchInfoRequest extends $pb.GeneratedMessage {
  factory StreamMatchInfoRequest() => create();

  StreamMatchInfoRequest._();

  factory StreamMatchInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamMatchInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamMatchInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.fms'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamMatchInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamMatchInfoRequest copyWith(
          void Function(StreamMatchInfoRequest) updates) =>
      super.copyWith((message) => updates(message as StreamMatchInfoRequest))
          as StreamMatchInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamMatchInfoRequest create() => StreamMatchInfoRequest._();
  @$core.override
  StreamMatchInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamMatchInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamMatchInfoRequest>(create);
  static StreamMatchInfoRequest? _defaultInstance;
}

class StreamConnectionStatusRequest extends $pb.GeneratedMessage {
  factory StreamConnectionStatusRequest() => create();

  StreamConnectionStatusRequest._();

  factory StreamConnectionStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamConnectionStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamConnectionStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.fms'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamConnectionStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamConnectionStatusRequest copyWith(
          void Function(StreamConnectionStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StreamConnectionStatusRequest))
          as StreamConnectionStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamConnectionStatusRequest create() =>
      StreamConnectionStatusRequest._();
  @$core.override
  StreamConnectionStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamConnectionStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamConnectionStatusRequest>(create);
  static StreamConnectionStatusRequest? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
