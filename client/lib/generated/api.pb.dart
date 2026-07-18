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

class MatchStationState extends $pb.GeneratedMessage {
  factory MatchStationState({
    $core.String? teamNumber,
    $core.bool? bypassed,
    $1.TeamAllianceStationType? allianceStation,
  }) {
    final result = create();
    if (teamNumber != null) result.teamNumber = teamNumber;
    if (bypassed != null) result.bypassed = bypassed;
    if (allianceStation != null) result.allianceStation = allianceStation;
    return result;
  }

  MatchStationState._();

  factory MatchStationState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchStationState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchStationState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'teamNumber')
    ..aOB(2, _omitFieldNames ? '' : 'bypassed')
    ..aE<$1.TeamAllianceStationType>(
        3, _omitFieldNames ? '' : 'allianceStation',
        enumValues: $1.TeamAllianceStationType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchStationState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchStationState copyWith(void Function(MatchStationState) updates) =>
      super.copyWith((message) => updates(message as MatchStationState))
          as MatchStationState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchStationState create() => MatchStationState._();
  @$core.override
  MatchStationState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchStationState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchStationState>(create);
  static MatchStationState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get teamNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set teamNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTeamNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearTeamNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get bypassed => $_getBF(1);
  @$pb.TagNumber(2)
  set bypassed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBypassed() => $_has(1);
  @$pb.TagNumber(2)
  void clearBypassed() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.TeamAllianceStationType get allianceStation => $_getN(2);
  @$pb.TagNumber(3)
  set allianceStation($1.TeamAllianceStationType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAllianceStation() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllianceStation() => $_clearField(3);
}

class MatchAllianceState extends $pb.GeneratedMessage {
  factory MatchAllianceState({
    MatchStationState? allianceTeam1State,
    MatchStationState? allianceTeam2State,
    MatchStationState? allianceTeam3State,
  }) {
    final result = create();
    if (allianceTeam1State != null)
      result.allianceTeam1State = allianceTeam1State;
    if (allianceTeam2State != null)
      result.allianceTeam2State = allianceTeam2State;
    if (allianceTeam3State != null)
      result.allianceTeam3State = allianceTeam3State;
    return result;
  }

  MatchAllianceState._();

  factory MatchAllianceState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchAllianceState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchAllianceState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aOM<MatchStationState>(1, _omitFieldNames ? '' : 'allianceTeam1State',
        protoName: 'alliance_team_1_state',
        subBuilder: MatchStationState.create)
    ..aOM<MatchStationState>(2, _omitFieldNames ? '' : 'allianceTeam2State',
        protoName: 'alliance_team_2_state',
        subBuilder: MatchStationState.create)
    ..aOM<MatchStationState>(3, _omitFieldNames ? '' : 'allianceTeam3State',
        protoName: 'alliance_team_3_state',
        subBuilder: MatchStationState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchAllianceState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchAllianceState copyWith(void Function(MatchAllianceState) updates) =>
      super.copyWith((message) => updates(message as MatchAllianceState))
          as MatchAllianceState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchAllianceState create() => MatchAllianceState._();
  @$core.override
  MatchAllianceState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchAllianceState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchAllianceState>(create);
  static MatchAllianceState? _defaultInstance;

  @$pb.TagNumber(1)
  MatchStationState get allianceTeam1State => $_getN(0);
  @$pb.TagNumber(1)
  set allianceTeam1State(MatchStationState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAllianceTeam1State() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllianceTeam1State() => $_clearField(1);
  @$pb.TagNumber(1)
  MatchStationState ensureAllianceTeam1State() => $_ensure(0);

  @$pb.TagNumber(2)
  MatchStationState get allianceTeam2State => $_getN(1);
  @$pb.TagNumber(2)
  set allianceTeam2State(MatchStationState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAllianceTeam2State() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllianceTeam2State() => $_clearField(2);
  @$pb.TagNumber(2)
  MatchStationState ensureAllianceTeam2State() => $_ensure(1);

  @$pb.TagNumber(3)
  MatchStationState get allianceTeam3State => $_getN(2);
  @$pb.TagNumber(3)
  set allianceTeam3State(MatchStationState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAllianceTeam3State() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllianceTeam3State() => $_clearField(3);
  @$pb.TagNumber(3)
  MatchStationState ensureAllianceTeam3State() => $_ensure(2);
}

class RefereeStreamResponse extends $pb.GeneratedMessage {
  factory RefereeStreamResponse({
    $core.int? matchId,
    $1.MatchPhase? matchPhase,
    MatchAllianceState? redAllianceState,
    MatchAllianceState? blueAllianceState,
    $1.RefereePanelState? partnerPanel,
    $core.int? rotateIn,
    $core.bool? refReviewRequired,
  }) {
    final result = create();
    if (matchId != null) result.matchId = matchId;
    if (matchPhase != null) result.matchPhase = matchPhase;
    if (redAllianceState != null) result.redAllianceState = redAllianceState;
    if (blueAllianceState != null) result.blueAllianceState = blueAllianceState;
    if (partnerPanel != null) result.partnerPanel = partnerPanel;
    if (rotateIn != null) result.rotateIn = rotateIn;
    if (refReviewRequired != null) result.refReviewRequired = refReviewRequired;
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
    ..aOM<MatchAllianceState>(3, _omitFieldNames ? '' : 'redAllianceState',
        subBuilder: MatchAllianceState.create)
    ..aOM<MatchAllianceState>(4, _omitFieldNames ? '' : 'blueAllianceState',
        subBuilder: MatchAllianceState.create)
    ..aOM<$1.RefereePanelState>(5, _omitFieldNames ? '' : 'partnerPanel',
        subBuilder: $1.RefereePanelState.create)
    ..aI(7, _omitFieldNames ? '' : 'rotateIn')
    ..aOB(8, _omitFieldNames ? '' : 'refReviewRequired')
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
  MatchAllianceState get redAllianceState => $_getN(2);
  @$pb.TagNumber(3)
  set redAllianceState(MatchAllianceState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRedAllianceState() => $_has(2);
  @$pb.TagNumber(3)
  void clearRedAllianceState() => $_clearField(3);
  @$pb.TagNumber(3)
  MatchAllianceState ensureRedAllianceState() => $_ensure(2);

  @$pb.TagNumber(4)
  MatchAllianceState get blueAllianceState => $_getN(3);
  @$pb.TagNumber(4)
  set blueAllianceState(MatchAllianceState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBlueAllianceState() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlueAllianceState() => $_clearField(4);
  @$pb.TagNumber(4)
  MatchAllianceState ensureBlueAllianceState() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.RefereePanelState get partnerPanel => $_getN(4);
  @$pb.TagNumber(5)
  set partnerPanel($1.RefereePanelState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPartnerPanel() => $_has(4);
  @$pb.TagNumber(5)
  void clearPartnerPanel() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.RefereePanelState ensurePartnerPanel() => $_ensure(4);

  /// Matches remaining until rotation (0 = rotate now) - the client derives whether/when to
  /// notify from this rather than a separate boolean.
  @$pb.TagNumber(7)
  $core.int get rotateIn => $_getIZ(5);
  @$pb.TagNumber(7)
  set rotateIn($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(7)
  $core.bool hasRotateIn() => $_has(5);
  @$pb.TagNumber(7)
  void clearRotateIn() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get refReviewRequired => $_getBF(6);
  @$pb.TagNumber(8)
  set refReviewRequired($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(8)
  $core.bool hasRefReviewRequired() => $_has(6);
  @$pb.TagNumber(8)
  void clearRefReviewRequired() => $_clearField(8);
}

class HeadRefereeStreamRequest extends $pb.GeneratedMessage {
  factory HeadRefereeStreamRequest({
    $core.int? matchId,
    $1.HeadRefereePanelState? state,
  }) {
    final result = create();
    if (matchId != null) result.matchId = matchId;
    if (state != null) result.state = state;
    return result;
  }

  HeadRefereeStreamRequest._();

  factory HeadRefereeStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeadRefereeStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeadRefereeStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'matchId')
    ..aOM<$1.HeadRefereePanelState>(2, _omitFieldNames ? '' : 'state',
        subBuilder: $1.HeadRefereePanelState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeadRefereeStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeadRefereeStreamRequest copyWith(
          void Function(HeadRefereeStreamRequest) updates) =>
      super.copyWith((message) => updates(message as HeadRefereeStreamRequest))
          as HeadRefereeStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeadRefereeStreamRequest create() => HeadRefereeStreamRequest._();
  @$core.override
  HeadRefereeStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeadRefereeStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeadRefereeStreamRequest>(create);
  static HeadRefereeStreamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get matchId => $_getIZ(0);
  @$pb.TagNumber(1)
  set matchId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.HeadRefereePanelState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state($1.HeadRefereePanelState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.HeadRefereePanelState ensureState() => $_ensure(1);
}

/// Whether each of the four regular referee panels currently has a live connection to the
/// server - internal to RefLink, unrelated to Cheesy Arena.
class PanelPresence extends $pb.GeneratedMessage {
  factory PanelPresence({
    $core.bool? rn,
    $core.bool? rf,
    $core.bool? bn,
    $core.bool? bf,
  }) {
    final result = create();
    if (rn != null) result.rn = rn;
    if (rf != null) result.rf = rf;
    if (bn != null) result.bn = bn;
    if (bf != null) result.bf = bf;
    return result;
  }

  PanelPresence._();

  factory PanelPresence.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PanelPresence.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PanelPresence',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'rn')
    ..aOB(2, _omitFieldNames ? '' : 'rf')
    ..aOB(3, _omitFieldNames ? '' : 'bn')
    ..aOB(4, _omitFieldNames ? '' : 'bf')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PanelPresence clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PanelPresence copyWith(void Function(PanelPresence) updates) =>
      super.copyWith((message) => updates(message as PanelPresence))
          as PanelPresence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PanelPresence create() => PanelPresence._();
  @$core.override
  PanelPresence createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PanelPresence getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PanelPresence>(create);
  static PanelPresence? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get rn => $_getBF(0);
  @$pb.TagNumber(1)
  set rn($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRn() => $_has(0);
  @$pb.TagNumber(1)
  void clearRn() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get rf => $_getBF(1);
  @$pb.TagNumber(2)
  set rf($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRf() => $_has(1);
  @$pb.TagNumber(2)
  void clearRf() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get bn => $_getBF(2);
  @$pb.TagNumber(3)
  set bn($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBn() => $_has(2);
  @$pb.TagNumber(3)
  void clearBn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get bf => $_getBF(3);
  @$pb.TagNumber(4)
  set bf($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBf() => $_has(3);
  @$pb.TagNumber(4)
  void clearBf() => $_clearField(4);
}

class HeadRefereeStreamResponse extends $pb.GeneratedMessage {
  factory HeadRefereeStreamResponse({
    $core.int? matchId,
    $1.MatchPhase? matchPhase,
    MatchAllianceState? redAllianceState,
    MatchAllianceState? blueAllianceState,
    $1.RefereePanelState? rn,
    $1.RefereePanelState? rf,
    $1.RefereePanelState? bn,
    $1.RefereePanelState? bf,
    $core.int? rotateIn,
    PanelPresence? panelPresence,
    $1.HeadRefereePanelState? hr,
  }) {
    final result = create();
    if (matchId != null) result.matchId = matchId;
    if (matchPhase != null) result.matchPhase = matchPhase;
    if (redAllianceState != null) result.redAllianceState = redAllianceState;
    if (blueAllianceState != null) result.blueAllianceState = blueAllianceState;
    if (rn != null) result.rn = rn;
    if (rf != null) result.rf = rf;
    if (bn != null) result.bn = bn;
    if (bf != null) result.bf = bf;
    if (rotateIn != null) result.rotateIn = rotateIn;
    if (panelPresence != null) result.panelPresence = panelPresence;
    if (hr != null) result.hr = hr;
    return result;
  }

  HeadRefereeStreamResponse._();

  factory HeadRefereeStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeadRefereeStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeadRefereeStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'matchId')
    ..aE<$1.MatchPhase>(2, _omitFieldNames ? '' : 'matchPhase',
        enumValues: $1.MatchPhase.values)
    ..aOM<MatchAllianceState>(3, _omitFieldNames ? '' : 'redAllianceState',
        subBuilder: MatchAllianceState.create)
    ..aOM<MatchAllianceState>(4, _omitFieldNames ? '' : 'blueAllianceState',
        subBuilder: MatchAllianceState.create)
    ..aOM<$1.RefereePanelState>(5, _omitFieldNames ? '' : 'rn',
        subBuilder: $1.RefereePanelState.create)
    ..aOM<$1.RefereePanelState>(6, _omitFieldNames ? '' : 'rf',
        subBuilder: $1.RefereePanelState.create)
    ..aOM<$1.RefereePanelState>(7, _omitFieldNames ? '' : 'bn',
        subBuilder: $1.RefereePanelState.create)
    ..aOM<$1.RefereePanelState>(8, _omitFieldNames ? '' : 'bf',
        subBuilder: $1.RefereePanelState.create)
    ..aI(10, _omitFieldNames ? '' : 'rotateIn')
    ..aOM<PanelPresence>(11, _omitFieldNames ? '' : 'panelPresence',
        subBuilder: PanelPresence.create)
    ..aOM<$1.HeadRefereePanelState>(12, _omitFieldNames ? '' : 'hr',
        subBuilder: $1.HeadRefereePanelState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeadRefereeStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeadRefereeStreamResponse copyWith(
          void Function(HeadRefereeStreamResponse) updates) =>
      super.copyWith((message) => updates(message as HeadRefereeStreamResponse))
          as HeadRefereeStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeadRefereeStreamResponse create() => HeadRefereeStreamResponse._();
  @$core.override
  HeadRefereeStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeadRefereeStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeadRefereeStreamResponse>(create);
  static HeadRefereeStreamResponse? _defaultInstance;

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
  MatchAllianceState get redAllianceState => $_getN(2);
  @$pb.TagNumber(3)
  set redAllianceState(MatchAllianceState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRedAllianceState() => $_has(2);
  @$pb.TagNumber(3)
  void clearRedAllianceState() => $_clearField(3);
  @$pb.TagNumber(3)
  MatchAllianceState ensureRedAllianceState() => $_ensure(2);

  @$pb.TagNumber(4)
  MatchAllianceState get blueAllianceState => $_getN(3);
  @$pb.TagNumber(4)
  set blueAllianceState(MatchAllianceState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBlueAllianceState() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlueAllianceState() => $_clearField(4);
  @$pb.TagNumber(4)
  MatchAllianceState ensureBlueAllianceState() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.RefereePanelState get rn => $_getN(4);
  @$pb.TagNumber(5)
  set rn($1.RefereePanelState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRn() => $_has(4);
  @$pb.TagNumber(5)
  void clearRn() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.RefereePanelState ensureRn() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.RefereePanelState get rf => $_getN(5);
  @$pb.TagNumber(6)
  set rf($1.RefereePanelState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRf() => $_has(5);
  @$pb.TagNumber(6)
  void clearRf() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.RefereePanelState ensureRf() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.RefereePanelState get bn => $_getN(6);
  @$pb.TagNumber(7)
  set bn($1.RefereePanelState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBn() => $_has(6);
  @$pb.TagNumber(7)
  void clearBn() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.RefereePanelState ensureBn() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.RefereePanelState get bf => $_getN(7);
  @$pb.TagNumber(8)
  set bf($1.RefereePanelState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBf() => $_has(7);
  @$pb.TagNumber(8)
  void clearBf() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.RefereePanelState ensureBf() => $_ensure(7);

  @$pb.TagNumber(10)
  $core.int get rotateIn => $_getIZ(8);
  @$pb.TagNumber(10)
  set rotateIn($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(10)
  $core.bool hasRotateIn() => $_has(8);
  @$pb.TagNumber(10)
  void clearRotateIn() => $_clearField(10);

  @$pb.TagNumber(11)
  PanelPresence get panelPresence => $_getN(9);
  @$pb.TagNumber(11)
  set panelPresence(PanelPresence value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPanelPresence() => $_has(9);
  @$pb.TagNumber(11)
  void clearPanelPresence() => $_clearField(11);
  @$pb.TagNumber(11)
  PanelPresence ensurePanelPresence() => $_ensure(9);

  /// Echoes back the server's authoritative (clamped) copy of the head referee's own
  /// submitted state - notably `field_state`, since the one-way MATCH->COUNT->RESET
  /// transition is enforced server-side, not by the submitting client.
  @$pb.TagNumber(12)
  $1.HeadRefereePanelState get hr => $_getN(10);
  @$pb.TagNumber(12)
  set hr($1.HeadRefereePanelState value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasHr() => $_has(10);
  @$pb.TagNumber(12)
  void clearHr() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.HeadRefereePanelState ensureHr() => $_ensure(10);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
