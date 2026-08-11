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

/// ----- Server -> Client (published, retained, to reflink/match/state) -----
///
/// The one shared broadcast every tablet (including HR) subscribes to. A regular referee panel
/// derives its own "partner panel" locally from whichever of rn/rf/bn/bf matches its own panel
/// type (the same pairing `partner_panel_state()` used to compute server-side), and reads
/// `hr.ref_review_required` directly rather than a separate top-level duplicate of that field.
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

  /// Echoes back the server's authoritative (clamped) copy of the head referee's own
  /// submitted state - notably `field_state`, since the one-way MATCH->COUNT->RESET
  /// transition is enforced server-side, not by the submitting client.
  @$pb.TagNumber(12)
  $1.HeadRefereePanelState get hr => $_getN(9);
  @$pb.TagNumber(12)
  set hr($1.HeadRefereePanelState value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasHr() => $_has(9);
  @$pb.TagNumber(12)
  void clearHr() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.HeadRefereePanelState ensureHr() => $_ensure(9);
}

/// Fire-once, "ask Cheesy Arena to flip this station's bypass" - deliberately not part of
/// HeadRefereeStreamRequest's persisted state. Cheesy Arena is the sole owner of whether a
/// station is actually bypassed (already reflected back via MatchStationState.bypassed); we
/// never store our own copy of "should this be bypassed" to reconcile against, since Cheesy's
/// own `toggleBypass` is a plain toggle and anything else (the scorekeeper's own UI, a field
/// reset) is just as entitled to flip it.
class ToggleBypassRequest extends $pb.GeneratedMessage {
  factory ToggleBypassRequest({
    $1.TeamAllianceStationType? station,
  }) {
    final result = create();
    if (station != null) result.station = station;
    return result;
  }

  ToggleBypassRequest._();

  factory ToggleBypassRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToggleBypassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleBypassRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..aE<$1.TeamAllianceStationType>(1, _omitFieldNames ? '' : 'station',
        enumValues: $1.TeamAllianceStationType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleBypassRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleBypassRequest copyWith(void Function(ToggleBypassRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleBypassRequest))
          as ToggleBypassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToggleBypassRequest create() => ToggleBypassRequest._();
  @$core.override
  ToggleBypassRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToggleBypassRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleBypassRequest>(create);
  static ToggleBypassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.TeamAllianceStationType get station => $_getN(0);
  @$pb.TagNumber(1)
  set station($1.TeamAllianceStationType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStation() => $_has(0);
  @$pb.TagNumber(1)
  void clearStation() => $_clearField(1);
}

class ToggleBypassResponse extends $pb.GeneratedMessage {
  factory ToggleBypassResponse() => create();

  ToggleBypassResponse._();

  factory ToggleBypassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToggleBypassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleBypassResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleBypassResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleBypassResponse copyWith(void Function(ToggleBypassResponse) updates) =>
      super.copyWith((message) => updates(message as ToggleBypassResponse))
          as ToggleBypassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToggleBypassResponse create() => ToggleBypassResponse._();
  @$core.override
  ToggleBypassResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToggleBypassResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleBypassResponse>(create);
  static ToggleBypassResponse? _defaultInstance;
}

/// Fire-once, "ask Cheesy Arena to commit the fouls/cards and post the score, then load the
/// next match" - the same `commitAndPost` command Cheesy Arena's own referee panel and
/// scorekeeper match play page send (see web/referee_panel.go). Only meaningful once the match
/// has actually reached PostMatch; Cheesy Arena itself silently ignores it otherwise, so
/// there's nothing extra to check client- or server-side.
class CommitAndPostRequest extends $pb.GeneratedMessage {
  factory CommitAndPostRequest() => create();

  CommitAndPostRequest._();

  factory CommitAndPostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommitAndPostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommitAndPostRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommitAndPostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommitAndPostRequest copyWith(void Function(CommitAndPostRequest) updates) =>
      super.copyWith((message) => updates(message as CommitAndPostRequest))
          as CommitAndPostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommitAndPostRequest create() => CommitAndPostRequest._();
  @$core.override
  CommitAndPostRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommitAndPostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommitAndPostRequest>(create);
  static CommitAndPostRequest? _defaultInstance;
}

class CommitAndPostResponse extends $pb.GeneratedMessage {
  factory CommitAndPostResponse() => create();

  CommitAndPostResponse._();

  factory CommitAndPostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommitAndPostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommitAndPostResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommitAndPostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommitAndPostResponse copyWith(
          void Function(CommitAndPostResponse) updates) =>
      super.copyWith((message) => updates(message as CommitAndPostResponse))
          as CommitAndPostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommitAndPostResponse create() => CommitAndPostResponse._();
  @$core.override
  CommitAndPostResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommitAndPostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommitAndPostResponse>(create);
  static CommitAndPostResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
