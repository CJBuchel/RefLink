// This is a generated file - do not edit.
//
// Generated from db.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pb.dart';

class MatchStateRecord extends $pb.GeneratedMessage {
  factory MatchStateRecord({
    $core.int? matchId,
    $0.MatchPhase? matchPhase,
    $0.HeadRefereePanelState? hr,
    $0.RefereePanelState? rn,
    $0.RefereePanelState? rf,
    $0.RefereePanelState? bn,
    $0.RefereePanelState? bf,
    $core.bool? completed,
  }) {
    final result = create();
    if (matchId != null) result.matchId = matchId;
    if (matchPhase != null) result.matchPhase = matchPhase;
    if (hr != null) result.hr = hr;
    if (rn != null) result.rn = rn;
    if (rf != null) result.rf = rf;
    if (bn != null) result.bn = bn;
    if (bf != null) result.bf = bf;
    if (completed != null) result.completed = completed;
    return result;
  }

  MatchStateRecord._();

  factory MatchStateRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchStateRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchStateRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.db'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'matchId')
    ..aE<$0.MatchPhase>(2, _omitFieldNames ? '' : 'matchPhase',
        enumValues: $0.MatchPhase.values)
    ..aOM<$0.HeadRefereePanelState>(3, _omitFieldNames ? '' : 'hr',
        subBuilder: $0.HeadRefereePanelState.create)
    ..aOM<$0.RefereePanelState>(4, _omitFieldNames ? '' : 'rn',
        subBuilder: $0.RefereePanelState.create)
    ..aOM<$0.RefereePanelState>(5, _omitFieldNames ? '' : 'rf',
        subBuilder: $0.RefereePanelState.create)
    ..aOM<$0.RefereePanelState>(6, _omitFieldNames ? '' : 'bn',
        subBuilder: $0.RefereePanelState.create)
    ..aOM<$0.RefereePanelState>(7, _omitFieldNames ? '' : 'bf',
        subBuilder: $0.RefereePanelState.create)
    ..aOB(8, _omitFieldNames ? '' : 'completed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchStateRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchStateRecord copyWith(void Function(MatchStateRecord) updates) =>
      super.copyWith((message) => updates(message as MatchStateRecord))
          as MatchStateRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchStateRecord create() => MatchStateRecord._();
  @$core.override
  MatchStateRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchStateRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchStateRecord>(create);
  static MatchStateRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get matchId => $_getIZ(0);
  @$pb.TagNumber(1)
  set matchId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.MatchPhase get matchPhase => $_getN(1);
  @$pb.TagNumber(2)
  set matchPhase($0.MatchPhase value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchPhase() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchPhase() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.HeadRefereePanelState get hr => $_getN(2);
  @$pb.TagNumber(3)
  set hr($0.HeadRefereePanelState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasHr() => $_has(2);
  @$pb.TagNumber(3)
  void clearHr() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.HeadRefereePanelState ensureHr() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.RefereePanelState get rn => $_getN(3);
  @$pb.TagNumber(4)
  set rn($0.RefereePanelState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRn() => $_has(3);
  @$pb.TagNumber(4)
  void clearRn() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.RefereePanelState ensureRn() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.RefereePanelState get rf => $_getN(4);
  @$pb.TagNumber(5)
  set rf($0.RefereePanelState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRf() => $_has(4);
  @$pb.TagNumber(5)
  void clearRf() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.RefereePanelState ensureRf() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.RefereePanelState get bn => $_getN(5);
  @$pb.TagNumber(6)
  set bn($0.RefereePanelState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBn() => $_has(5);
  @$pb.TagNumber(6)
  void clearBn() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.RefereePanelState ensureBn() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.RefereePanelState get bf => $_getN(6);
  @$pb.TagNumber(7)
  set bf($0.RefereePanelState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBf() => $_has(6);
  @$pb.TagNumber(7)
  void clearBf() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.RefereePanelState ensureBf() => $_ensure(6);

  /// Set once this match has reached PostMatch state in Cheesy Arena - distinguishes a match
  /// that was actually run to completion from one that was merely loaded/previewed. Chosen
  /// over Cheesy's `scorePosted` event because the field_monitor websocket we connect to
  /// doesn't subscribe to that notifier, only to arenaStatus/matchTime.
  @$pb.TagNumber(8)
  $core.bool get completed => $_getBF(7);
  @$pb.TagNumber(8)
  set completed($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCompleted() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompleted() => $_clearField(8);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
