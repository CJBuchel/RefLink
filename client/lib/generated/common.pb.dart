// This is a generated file - do not edit.
//
// Generated from common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

class MatchFouls extends $pb.GeneratedMessage {
  factory MatchFouls({
    $core.int? redMinorFouls,
    $core.int? redMajorFouls,
    $core.int? blueMinorFouls,
    $core.int? blueMajorFouls,
  }) {
    final result = create();
    if (redMinorFouls != null) result.redMinorFouls = redMinorFouls;
    if (redMajorFouls != null) result.redMajorFouls = redMajorFouls;
    if (blueMinorFouls != null) result.blueMinorFouls = blueMinorFouls;
    if (blueMajorFouls != null) result.blueMajorFouls = blueMajorFouls;
    return result;
  }

  MatchFouls._();

  factory MatchFouls.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchFouls.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchFouls',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.common'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'redMinorFouls')
    ..aI(2, _omitFieldNames ? '' : 'redMajorFouls')
    ..aI(3, _omitFieldNames ? '' : 'blueMinorFouls')
    ..aI(4, _omitFieldNames ? '' : 'blueMajorFouls')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchFouls clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchFouls copyWith(void Function(MatchFouls) updates) =>
      super.copyWith((message) => updates(message as MatchFouls)) as MatchFouls;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchFouls create() => MatchFouls._();
  @$core.override
  MatchFouls createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchFouls getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchFouls>(create);
  static MatchFouls? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get redMinorFouls => $_getIZ(0);
  @$pb.TagNumber(1)
  set redMinorFouls($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRedMinorFouls() => $_has(0);
  @$pb.TagNumber(1)
  void clearRedMinorFouls() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get redMajorFouls => $_getIZ(1);
  @$pb.TagNumber(2)
  set redMajorFouls($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRedMajorFouls() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedMajorFouls() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get blueMinorFouls => $_getIZ(2);
  @$pb.TagNumber(3)
  set blueMinorFouls($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBlueMinorFouls() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlueMinorFouls() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get blueMajorFouls => $_getIZ(3);
  @$pb.TagNumber(4)
  set blueMajorFouls($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBlueMajorFouls() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlueMajorFouls() => $_clearField(4);
}

class MatchCards extends $pb.GeneratedMessage {
  factory MatchCards({
    CardType? redAllianceStation1,
    CardType? redAllianceStation2,
    CardType? redAllianceStation3,
    CardType? blueAllianceStation1,
    CardType? blueAllianceStation2,
    CardType? blueAllianceStation3,
  }) {
    final result = create();
    if (redAllianceStation1 != null)
      result.redAllianceStation1 = redAllianceStation1;
    if (redAllianceStation2 != null)
      result.redAllianceStation2 = redAllianceStation2;
    if (redAllianceStation3 != null)
      result.redAllianceStation3 = redAllianceStation3;
    if (blueAllianceStation1 != null)
      result.blueAllianceStation1 = blueAllianceStation1;
    if (blueAllianceStation2 != null)
      result.blueAllianceStation2 = blueAllianceStation2;
    if (blueAllianceStation3 != null)
      result.blueAllianceStation3 = blueAllianceStation3;
    return result;
  }

  MatchCards._();

  factory MatchCards.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchCards.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchCards',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.common'),
      createEmptyInstance: create)
    ..aE<CardType>(1, _omitFieldNames ? '' : 'redAllianceStation1',
        protoName: 'red_alliance_station_1', enumValues: CardType.values)
    ..aE<CardType>(2, _omitFieldNames ? '' : 'redAllianceStation2',
        protoName: 'red_alliance_station_2', enumValues: CardType.values)
    ..aE<CardType>(3, _omitFieldNames ? '' : 'redAllianceStation3',
        protoName: 'red_alliance_station_3', enumValues: CardType.values)
    ..aE<CardType>(4, _omitFieldNames ? '' : 'blueAllianceStation1',
        protoName: 'blue_alliance_station_1', enumValues: CardType.values)
    ..aE<CardType>(5, _omitFieldNames ? '' : 'blueAllianceStation2',
        protoName: 'blue_alliance_station_2', enumValues: CardType.values)
    ..aE<CardType>(6, _omitFieldNames ? '' : 'blueAllianceStation3',
        protoName: 'blue_alliance_station_3', enumValues: CardType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchCards clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchCards copyWith(void Function(MatchCards) updates) =>
      super.copyWith((message) => updates(message as MatchCards)) as MatchCards;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchCards create() => MatchCards._();
  @$core.override
  MatchCards createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchCards getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchCards>(create);
  static MatchCards? _defaultInstance;

  @$pb.TagNumber(1)
  CardType get redAllianceStation1 => $_getN(0);
  @$pb.TagNumber(1)
  set redAllianceStation1(CardType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRedAllianceStation1() => $_has(0);
  @$pb.TagNumber(1)
  void clearRedAllianceStation1() => $_clearField(1);

  @$pb.TagNumber(2)
  CardType get redAllianceStation2 => $_getN(1);
  @$pb.TagNumber(2)
  set redAllianceStation2(CardType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRedAllianceStation2() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedAllianceStation2() => $_clearField(2);

  @$pb.TagNumber(3)
  CardType get redAllianceStation3 => $_getN(2);
  @$pb.TagNumber(3)
  set redAllianceStation3(CardType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRedAllianceStation3() => $_has(2);
  @$pb.TagNumber(3)
  void clearRedAllianceStation3() => $_clearField(3);

  @$pb.TagNumber(4)
  CardType get blueAllianceStation1 => $_getN(3);
  @$pb.TagNumber(4)
  set blueAllianceStation1(CardType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBlueAllianceStation1() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlueAllianceStation1() => $_clearField(4);

  @$pb.TagNumber(5)
  CardType get blueAllianceStation2 => $_getN(4);
  @$pb.TagNumber(5)
  set blueAllianceStation2(CardType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBlueAllianceStation2() => $_has(4);
  @$pb.TagNumber(5)
  void clearBlueAllianceStation2() => $_clearField(5);

  @$pb.TagNumber(6)
  CardType get blueAllianceStation3 => $_getN(5);
  @$pb.TagNumber(6)
  set blueAllianceStation3(CardType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBlueAllianceStation3() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlueAllianceStation3() => $_clearField(6);
}

class AllianceAutoClimb extends $pb.GeneratedMessage {
  factory AllianceAutoClimb({
    AutoClimbState? autoClimbAllianceStation1,
    AutoClimbState? autoClimbAllianceStation2,
    AutoClimbState? autoClimbAllianceStation3,
  }) {
    final result = create();
    if (autoClimbAllianceStation1 != null)
      result.autoClimbAllianceStation1 = autoClimbAllianceStation1;
    if (autoClimbAllianceStation2 != null)
      result.autoClimbAllianceStation2 = autoClimbAllianceStation2;
    if (autoClimbAllianceStation3 != null)
      result.autoClimbAllianceStation3 = autoClimbAllianceStation3;
    return result;
  }

  AllianceAutoClimb._();

  factory AllianceAutoClimb.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AllianceAutoClimb.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AllianceAutoClimb',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.common'),
      createEmptyInstance: create)
    ..aE<AutoClimbState>(1, _omitFieldNames ? '' : 'autoClimbAllianceStation1',
        protoName: 'auto_climb_alliance_station_1',
        enumValues: AutoClimbState.values)
    ..aE<AutoClimbState>(2, _omitFieldNames ? '' : 'autoClimbAllianceStation2',
        protoName: 'auto_climb_alliance_station_2',
        enumValues: AutoClimbState.values)
    ..aE<AutoClimbState>(3, _omitFieldNames ? '' : 'autoClimbAllianceStation3',
        protoName: 'auto_climb_alliance_station_3',
        enumValues: AutoClimbState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllianceAutoClimb clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllianceAutoClimb copyWith(void Function(AllianceAutoClimb) updates) =>
      super.copyWith((message) => updates(message as AllianceAutoClimb))
          as AllianceAutoClimb;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllianceAutoClimb create() => AllianceAutoClimb._();
  @$core.override
  AllianceAutoClimb createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AllianceAutoClimb getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AllianceAutoClimb>(create);
  static AllianceAutoClimb? _defaultInstance;

  @$pb.TagNumber(1)
  AutoClimbState get autoClimbAllianceStation1 => $_getN(0);
  @$pb.TagNumber(1)
  set autoClimbAllianceStation1(AutoClimbState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAutoClimbAllianceStation1() => $_has(0);
  @$pb.TagNumber(1)
  void clearAutoClimbAllianceStation1() => $_clearField(1);

  @$pb.TagNumber(2)
  AutoClimbState get autoClimbAllianceStation2 => $_getN(1);
  @$pb.TagNumber(2)
  set autoClimbAllianceStation2(AutoClimbState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoClimbAllianceStation2() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoClimbAllianceStation2() => $_clearField(2);

  @$pb.TagNumber(3)
  AutoClimbState get autoClimbAllianceStation3 => $_getN(2);
  @$pb.TagNumber(3)
  set autoClimbAllianceStation3(AutoClimbState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAutoClimbAllianceStation3() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutoClimbAllianceStation3() => $_clearField(3);
}

class AllianceEndgameClimb extends $pb.GeneratedMessage {
  factory AllianceEndgameClimb({
    EndgameClimbState? endgameClimbAllianceStation1,
    EndgameClimbState? endgameClimbAllianceStation2,
    EndgameClimbState? endgameClimbAllianceStation3,
  }) {
    final result = create();
    if (endgameClimbAllianceStation1 != null)
      result.endgameClimbAllianceStation1 = endgameClimbAllianceStation1;
    if (endgameClimbAllianceStation2 != null)
      result.endgameClimbAllianceStation2 = endgameClimbAllianceStation2;
    if (endgameClimbAllianceStation3 != null)
      result.endgameClimbAllianceStation3 = endgameClimbAllianceStation3;
    return result;
  }

  AllianceEndgameClimb._();

  factory AllianceEndgameClimb.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AllianceEndgameClimb.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AllianceEndgameClimb',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.common'),
      createEmptyInstance: create)
    ..aE<EndgameClimbState>(
        1, _omitFieldNames ? '' : 'endgameClimbAllianceStation1',
        protoName: 'endgame_climb_alliance_station_1',
        enumValues: EndgameClimbState.values)
    ..aE<EndgameClimbState>(
        2, _omitFieldNames ? '' : 'endgameClimbAllianceStation2',
        protoName: 'endgame_climb_alliance_station_2',
        enumValues: EndgameClimbState.values)
    ..aE<EndgameClimbState>(
        3, _omitFieldNames ? '' : 'endgameClimbAllianceStation3',
        protoName: 'endgame_climb_alliance_station_3',
        enumValues: EndgameClimbState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllianceEndgameClimb clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AllianceEndgameClimb copyWith(void Function(AllianceEndgameClimb) updates) =>
      super.copyWith((message) => updates(message as AllianceEndgameClimb))
          as AllianceEndgameClimb;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllianceEndgameClimb create() => AllianceEndgameClimb._();
  @$core.override
  AllianceEndgameClimb createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AllianceEndgameClimb getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AllianceEndgameClimb>(create);
  static AllianceEndgameClimb? _defaultInstance;

  @$pb.TagNumber(1)
  EndgameClimbState get endgameClimbAllianceStation1 => $_getN(0);
  @$pb.TagNumber(1)
  set endgameClimbAllianceStation1(EndgameClimbState value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEndgameClimbAllianceStation1() => $_has(0);
  @$pb.TagNumber(1)
  void clearEndgameClimbAllianceStation1() => $_clearField(1);

  @$pb.TagNumber(2)
  EndgameClimbState get endgameClimbAllianceStation2 => $_getN(1);
  @$pb.TagNumber(2)
  set endgameClimbAllianceStation2(EndgameClimbState value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndgameClimbAllianceStation2() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndgameClimbAllianceStation2() => $_clearField(2);

  @$pb.TagNumber(3)
  EndgameClimbState get endgameClimbAllianceStation3 => $_getN(2);
  @$pb.TagNumber(3)
  set endgameClimbAllianceStation3(EndgameClimbState value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEndgameClimbAllianceStation3() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndgameClimbAllianceStation3() => $_clearField(3);
}

class RefereePanelState extends $pb.GeneratedMessage {
  factory RefereePanelState({
    RefereeVote? refereeVote,
    AllianceAutoClimb? autoClimb,
    $core.bool? autoSubmitted,
    $core.bool? autoIssue,
    MatchFouls? matchFouls,
    MatchCards? matchCards,
    $core.bool? rpIssue,
    $core.bool? discussionNeeded,
    AllianceEndgameClimb? endgameClimb,
    $core.bool? endgameSubmitted,
    $core.bool? endgameIssue,
  }) {
    final result = create();
    if (refereeVote != null) result.refereeVote = refereeVote;
    if (autoClimb != null) result.autoClimb = autoClimb;
    if (autoSubmitted != null) result.autoSubmitted = autoSubmitted;
    if (autoIssue != null) result.autoIssue = autoIssue;
    if (matchFouls != null) result.matchFouls = matchFouls;
    if (matchCards != null) result.matchCards = matchCards;
    if (rpIssue != null) result.rpIssue = rpIssue;
    if (discussionNeeded != null) result.discussionNeeded = discussionNeeded;
    if (endgameClimb != null) result.endgameClimb = endgameClimb;
    if (endgameSubmitted != null) result.endgameSubmitted = endgameSubmitted;
    if (endgameIssue != null) result.endgameIssue = endgameIssue;
    return result;
  }

  RefereePanelState._();

  factory RefereePanelState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefereePanelState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefereePanelState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.common'),
      createEmptyInstance: create)
    ..aE<RefereeVote>(1, _omitFieldNames ? '' : 'refereeVote',
        enumValues: RefereeVote.values)
    ..aOM<AllianceAutoClimb>(2, _omitFieldNames ? '' : 'autoClimb',
        subBuilder: AllianceAutoClimb.create)
    ..aOB(3, _omitFieldNames ? '' : 'autoSubmitted')
    ..aOB(4, _omitFieldNames ? '' : 'autoIssue')
    ..aOM<MatchFouls>(5, _omitFieldNames ? '' : 'matchFouls',
        subBuilder: MatchFouls.create)
    ..aOM<MatchCards>(6, _omitFieldNames ? '' : 'matchCards',
        subBuilder: MatchCards.create)
    ..aOB(7, _omitFieldNames ? '' : 'rpIssue')
    ..aOB(8, _omitFieldNames ? '' : 'discussionNeeded')
    ..aOM<AllianceEndgameClimb>(9, _omitFieldNames ? '' : 'endgameClimb',
        subBuilder: AllianceEndgameClimb.create)
    ..aOB(10, _omitFieldNames ? '' : 'endgameSubmitted')
    ..aOB(11, _omitFieldNames ? '' : 'endgameIssue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefereePanelState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefereePanelState copyWith(void Function(RefereePanelState) updates) =>
      super.copyWith((message) => updates(message as RefereePanelState))
          as RefereePanelState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefereePanelState create() => RefereePanelState._();
  @$core.override
  RefereePanelState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefereePanelState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefereePanelState>(create);
  static RefereePanelState? _defaultInstance;

  @$pb.TagNumber(1)
  RefereeVote get refereeVote => $_getN(0);
  @$pb.TagNumber(1)
  set refereeVote(RefereeVote value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRefereeVote() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefereeVote() => $_clearField(1);

  @$pb.TagNumber(2)
  AllianceAutoClimb get autoClimb => $_getN(1);
  @$pb.TagNumber(2)
  set autoClimb(AllianceAutoClimb value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoClimb() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoClimb() => $_clearField(2);
  @$pb.TagNumber(2)
  AllianceAutoClimb ensureAutoClimb() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get autoSubmitted => $_getBF(2);
  @$pb.TagNumber(3)
  set autoSubmitted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAutoSubmitted() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutoSubmitted() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get autoIssue => $_getBF(3);
  @$pb.TagNumber(4)
  set autoIssue($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAutoIssue() => $_has(3);
  @$pb.TagNumber(4)
  void clearAutoIssue() => $_clearField(4);

  @$pb.TagNumber(5)
  MatchFouls get matchFouls => $_getN(4);
  @$pb.TagNumber(5)
  set matchFouls(MatchFouls value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMatchFouls() => $_has(4);
  @$pb.TagNumber(5)
  void clearMatchFouls() => $_clearField(5);
  @$pb.TagNumber(5)
  MatchFouls ensureMatchFouls() => $_ensure(4);

  @$pb.TagNumber(6)
  MatchCards get matchCards => $_getN(5);
  @$pb.TagNumber(6)
  set matchCards(MatchCards value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMatchCards() => $_has(5);
  @$pb.TagNumber(6)
  void clearMatchCards() => $_clearField(6);
  @$pb.TagNumber(6)
  MatchCards ensureMatchCards() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get rpIssue => $_getBF(6);
  @$pb.TagNumber(7)
  set rpIssue($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRpIssue() => $_has(6);
  @$pb.TagNumber(7)
  void clearRpIssue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get discussionNeeded => $_getBF(7);
  @$pb.TagNumber(8)
  set discussionNeeded($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDiscussionNeeded() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiscussionNeeded() => $_clearField(8);

  @$pb.TagNumber(9)
  AllianceEndgameClimb get endgameClimb => $_getN(8);
  @$pb.TagNumber(9)
  set endgameClimb(AllianceEndgameClimb value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndgameClimb() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndgameClimb() => $_clearField(9);
  @$pb.TagNumber(9)
  AllianceEndgameClimb ensureEndgameClimb() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.bool get endgameSubmitted => $_getBF(9);
  @$pb.TagNumber(10)
  set endgameSubmitted($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEndgameSubmitted() => $_has(9);
  @$pb.TagNumber(10)
  void clearEndgameSubmitted() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get endgameIssue => $_getBF(10);
  @$pb.TagNumber(11)
  set endgameIssue($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEndgameIssue() => $_has(10);
  @$pb.TagNumber(11)
  void clearEndgameIssue() => $_clearField(11);
}

class HeadRefereePanelState extends $pb.GeneratedMessage {
  factory HeadRefereePanelState({
    MatchFouls? matchFouls,
    MatchCards? matchCards,
    $core.bool? refReviewRequired,
    FieldState? fieldState,
    $core.bool? twoMinuteWarningGiven,
    $fixnum.Int64? twoMinuteWarningExpiresAtUnixSec,
  }) {
    final result = create();
    if (matchFouls != null) result.matchFouls = matchFouls;
    if (matchCards != null) result.matchCards = matchCards;
    if (refReviewRequired != null) result.refReviewRequired = refReviewRequired;
    if (fieldState != null) result.fieldState = fieldState;
    if (twoMinuteWarningGiven != null)
      result.twoMinuteWarningGiven = twoMinuteWarningGiven;
    if (twoMinuteWarningExpiresAtUnixSec != null)
      result.twoMinuteWarningExpiresAtUnixSec =
          twoMinuteWarningExpiresAtUnixSec;
    return result;
  }

  HeadRefereePanelState._();

  factory HeadRefereePanelState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeadRefereePanelState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeadRefereePanelState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reflink.common'),
      createEmptyInstance: create)
    ..aOM<MatchFouls>(1, _omitFieldNames ? '' : 'matchFouls',
        subBuilder: MatchFouls.create)
    ..aOM<MatchCards>(2, _omitFieldNames ? '' : 'matchCards',
        subBuilder: MatchCards.create)
    ..aOB(3, _omitFieldNames ? '' : 'refReviewRequired')
    ..aE<FieldState>(4, _omitFieldNames ? '' : 'fieldState',
        enumValues: FieldState.values)
    ..aOB(5, _omitFieldNames ? '' : 'twoMinuteWarningGiven')
    ..aInt64(6, _omitFieldNames ? '' : 'twoMinuteWarningExpiresAtUnixSec')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeadRefereePanelState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeadRefereePanelState copyWith(
          void Function(HeadRefereePanelState) updates) =>
      super.copyWith((message) => updates(message as HeadRefereePanelState))
          as HeadRefereePanelState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeadRefereePanelState create() => HeadRefereePanelState._();
  @$core.override
  HeadRefereePanelState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeadRefereePanelState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeadRefereePanelState>(create);
  static HeadRefereePanelState? _defaultInstance;

  @$pb.TagNumber(1)
  MatchFouls get matchFouls => $_getN(0);
  @$pb.TagNumber(1)
  set matchFouls(MatchFouls value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMatchFouls() => $_has(0);
  @$pb.TagNumber(1)
  void clearMatchFouls() => $_clearField(1);
  @$pb.TagNumber(1)
  MatchFouls ensureMatchFouls() => $_ensure(0);

  @$pb.TagNumber(2)
  MatchCards get matchCards => $_getN(1);
  @$pb.TagNumber(2)
  set matchCards(MatchCards value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMatchCards() => $_has(1);
  @$pb.TagNumber(2)
  void clearMatchCards() => $_clearField(2);
  @$pb.TagNumber(2)
  MatchCards ensureMatchCards() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get refReviewRequired => $_getBF(2);
  @$pb.TagNumber(3)
  set refReviewRequired($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefReviewRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefReviewRequired() => $_clearField(3);

  @$pb.TagNumber(4)
  FieldState get fieldState => $_getN(3);
  @$pb.TagNumber(4)
  set fieldState(FieldState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFieldState() => $_has(3);
  @$pb.TagNumber(4)
  void clearFieldState() => $_clearField(4);

  /// One-way per match cycle (never reverts to false except on a new match) - purely a local
  /// RefLink record that the warning has been given. Deliberately has no Cheesy Arena
  /// counterpart; see arena/repository.rs for why.
  @$pb.TagNumber(5)
  $core.bool get twoMinuteWarningGiven => $_getBF(4);
  @$pb.TagNumber(5)
  set twoMinuteWarningGiven($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTwoMinuteWarningGiven() => $_has(4);
  @$pb.TagNumber(5)
  void clearTwoMinuteWarningGiven() => $_clearField(5);

  /// Unix seconds when the 2-minute warning countdown ends - stamped server-side the instant
  /// two_minute_warning_given first becomes true (see arena/repository.rs), so every client
  /// renders the same countdown regardless of when it last heard from the server. 0 when not
  /// given yet.
  @$pb.TagNumber(6)
  $fixnum.Int64 get twoMinuteWarningExpiresAtUnixSec => $_getI64(5);
  @$pb.TagNumber(6)
  set twoMinuteWarningExpiresAtUnixSec($fixnum.Int64 value) =>
      $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTwoMinuteWarningExpiresAtUnixSec() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwoMinuteWarningExpiresAtUnixSec() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
