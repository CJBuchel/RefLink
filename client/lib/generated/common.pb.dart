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

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

class RefereePanelState extends $pb.GeneratedMessage {
  factory RefereePanelState({
    RefereeVote? refereeVote,
    AutoClimbState? autoClimbAllianceStation1,
    AutoClimbState? autoClimbAllianceStation2,
    AutoClimbState? autoClimbAllianceStation3,
    $core.bool? autoSubmitted,
    $core.bool? autoIssue,
    $core.int? redMinorFouls,
    $core.int? redMajorFouls,
    $core.int? blueMinorFouls,
    $core.int? blueMajorFouls,
    CardType? redAllianceStation1,
    CardType? redAllianceStation2,
    CardType? redAllianceStation3,
    CardType? blueAllianceStation1,
    CardType? blueAllianceStation2,
    CardType? blueAllianceStation3,
    $core.bool? rpIssue,
    $core.bool? discussionNeeded,
    EndgameClimbState? endgameClimbAllianceStation1,
    EndgameClimbState? endgameClimbAllianceStation2,
    EndgameClimbState? endgameClimbAllianceStation3,
    $core.bool? endgameSubmitted,
    $core.bool? endgameIssue,
  }) {
    final result = create();
    if (refereeVote != null) result.refereeVote = refereeVote;
    if (autoClimbAllianceStation1 != null)
      result.autoClimbAllianceStation1 = autoClimbAllianceStation1;
    if (autoClimbAllianceStation2 != null)
      result.autoClimbAllianceStation2 = autoClimbAllianceStation2;
    if (autoClimbAllianceStation3 != null)
      result.autoClimbAllianceStation3 = autoClimbAllianceStation3;
    if (autoSubmitted != null) result.autoSubmitted = autoSubmitted;
    if (autoIssue != null) result.autoIssue = autoIssue;
    if (redMinorFouls != null) result.redMinorFouls = redMinorFouls;
    if (redMajorFouls != null) result.redMajorFouls = redMajorFouls;
    if (blueMinorFouls != null) result.blueMinorFouls = blueMinorFouls;
    if (blueMajorFouls != null) result.blueMajorFouls = blueMajorFouls;
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
    if (rpIssue != null) result.rpIssue = rpIssue;
    if (discussionNeeded != null) result.discussionNeeded = discussionNeeded;
    if (endgameClimbAllianceStation1 != null)
      result.endgameClimbAllianceStation1 = endgameClimbAllianceStation1;
    if (endgameClimbAllianceStation2 != null)
      result.endgameClimbAllianceStation2 = endgameClimbAllianceStation2;
    if (endgameClimbAllianceStation3 != null)
      result.endgameClimbAllianceStation3 = endgameClimbAllianceStation3;
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
    ..aE<AutoClimbState>(2, _omitFieldNames ? '' : 'autoClimbAllianceStation1',
        protoName: 'auto_climb_alliance_station_1',
        enumValues: AutoClimbState.values)
    ..aE<AutoClimbState>(3, _omitFieldNames ? '' : 'autoClimbAllianceStation2',
        protoName: 'auto_climb_alliance_station_2',
        enumValues: AutoClimbState.values)
    ..aE<AutoClimbState>(4, _omitFieldNames ? '' : 'autoClimbAllianceStation3',
        protoName: 'auto_climb_alliance_station_3',
        enumValues: AutoClimbState.values)
    ..aOB(5, _omitFieldNames ? '' : 'autoSubmitted')
    ..aOB(6, _omitFieldNames ? '' : 'autoIssue')
    ..aI(7, _omitFieldNames ? '' : 'redMinorFouls')
    ..aI(8, _omitFieldNames ? '' : 'redMajorFouls')
    ..aI(9, _omitFieldNames ? '' : 'blueMinorFouls')
    ..aI(10, _omitFieldNames ? '' : 'blueMajorFouls')
    ..aE<CardType>(11, _omitFieldNames ? '' : 'redAllianceStation1',
        protoName: 'red_alliance_station_1', enumValues: CardType.values)
    ..aE<CardType>(12, _omitFieldNames ? '' : 'redAllianceStation2',
        protoName: 'red_alliance_station_2', enumValues: CardType.values)
    ..aE<CardType>(13, _omitFieldNames ? '' : 'redAllianceStation3',
        protoName: 'red_alliance_station_3', enumValues: CardType.values)
    ..aE<CardType>(14, _omitFieldNames ? '' : 'blueAllianceStation1',
        protoName: 'blue_alliance_station_1', enumValues: CardType.values)
    ..aE<CardType>(15, _omitFieldNames ? '' : 'blueAllianceStation2',
        protoName: 'blue_alliance_station_2', enumValues: CardType.values)
    ..aE<CardType>(16, _omitFieldNames ? '' : 'blueAllianceStation3',
        protoName: 'blue_alliance_station_3', enumValues: CardType.values)
    ..aOB(17, _omitFieldNames ? '' : 'rpIssue')
    ..aOB(18, _omitFieldNames ? '' : 'discussionNeeded')
    ..aE<EndgameClimbState>(
        19, _omitFieldNames ? '' : 'endgameClimbAllianceStation1',
        protoName: 'endgame_climb_alliance_station_1',
        enumValues: EndgameClimbState.values)
    ..aE<EndgameClimbState>(
        20, _omitFieldNames ? '' : 'endgameClimbAllianceStation2',
        protoName: 'endgame_climb_alliance_station_2',
        enumValues: EndgameClimbState.values)
    ..aE<EndgameClimbState>(
        21, _omitFieldNames ? '' : 'endgameClimbAllianceStation3',
        protoName: 'endgame_climb_alliance_station_3',
        enumValues: EndgameClimbState.values)
    ..aOB(22, _omitFieldNames ? '' : 'endgameSubmitted')
    ..aOB(23, _omitFieldNames ? '' : 'endgameIssue')
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
  AutoClimbState get autoClimbAllianceStation1 => $_getN(1);
  @$pb.TagNumber(2)
  set autoClimbAllianceStation1(AutoClimbState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAutoClimbAllianceStation1() => $_has(1);
  @$pb.TagNumber(2)
  void clearAutoClimbAllianceStation1() => $_clearField(2);

  @$pb.TagNumber(3)
  AutoClimbState get autoClimbAllianceStation2 => $_getN(2);
  @$pb.TagNumber(3)
  set autoClimbAllianceStation2(AutoClimbState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAutoClimbAllianceStation2() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutoClimbAllianceStation2() => $_clearField(3);

  @$pb.TagNumber(4)
  AutoClimbState get autoClimbAllianceStation3 => $_getN(3);
  @$pb.TagNumber(4)
  set autoClimbAllianceStation3(AutoClimbState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAutoClimbAllianceStation3() => $_has(3);
  @$pb.TagNumber(4)
  void clearAutoClimbAllianceStation3() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get autoSubmitted => $_getBF(4);
  @$pb.TagNumber(5)
  set autoSubmitted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAutoSubmitted() => $_has(4);
  @$pb.TagNumber(5)
  void clearAutoSubmitted() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get autoIssue => $_getBF(5);
  @$pb.TagNumber(6)
  set autoIssue($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAutoIssue() => $_has(5);
  @$pb.TagNumber(6)
  void clearAutoIssue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get redMinorFouls => $_getIZ(6);
  @$pb.TagNumber(7)
  set redMinorFouls($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRedMinorFouls() => $_has(6);
  @$pb.TagNumber(7)
  void clearRedMinorFouls() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get redMajorFouls => $_getIZ(7);
  @$pb.TagNumber(8)
  set redMajorFouls($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRedMajorFouls() => $_has(7);
  @$pb.TagNumber(8)
  void clearRedMajorFouls() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get blueMinorFouls => $_getIZ(8);
  @$pb.TagNumber(9)
  set blueMinorFouls($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBlueMinorFouls() => $_has(8);
  @$pb.TagNumber(9)
  void clearBlueMinorFouls() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get blueMajorFouls => $_getIZ(9);
  @$pb.TagNumber(10)
  set blueMajorFouls($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBlueMajorFouls() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlueMajorFouls() => $_clearField(10);

  @$pb.TagNumber(11)
  CardType get redAllianceStation1 => $_getN(10);
  @$pb.TagNumber(11)
  set redAllianceStation1(CardType value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRedAllianceStation1() => $_has(10);
  @$pb.TagNumber(11)
  void clearRedAllianceStation1() => $_clearField(11);

  @$pb.TagNumber(12)
  CardType get redAllianceStation2 => $_getN(11);
  @$pb.TagNumber(12)
  set redAllianceStation2(CardType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRedAllianceStation2() => $_has(11);
  @$pb.TagNumber(12)
  void clearRedAllianceStation2() => $_clearField(12);

  @$pb.TagNumber(13)
  CardType get redAllianceStation3 => $_getN(12);
  @$pb.TagNumber(13)
  set redAllianceStation3(CardType value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRedAllianceStation3() => $_has(12);
  @$pb.TagNumber(13)
  void clearRedAllianceStation3() => $_clearField(13);

  @$pb.TagNumber(14)
  CardType get blueAllianceStation1 => $_getN(13);
  @$pb.TagNumber(14)
  set blueAllianceStation1(CardType value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasBlueAllianceStation1() => $_has(13);
  @$pb.TagNumber(14)
  void clearBlueAllianceStation1() => $_clearField(14);

  @$pb.TagNumber(15)
  CardType get blueAllianceStation2 => $_getN(14);
  @$pb.TagNumber(15)
  set blueAllianceStation2(CardType value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasBlueAllianceStation2() => $_has(14);
  @$pb.TagNumber(15)
  void clearBlueAllianceStation2() => $_clearField(15);

  @$pb.TagNumber(16)
  CardType get blueAllianceStation3 => $_getN(15);
  @$pb.TagNumber(16)
  set blueAllianceStation3(CardType value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasBlueAllianceStation3() => $_has(15);
  @$pb.TagNumber(16)
  void clearBlueAllianceStation3() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get rpIssue => $_getBF(16);
  @$pb.TagNumber(17)
  set rpIssue($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRpIssue() => $_has(16);
  @$pb.TagNumber(17)
  void clearRpIssue() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get discussionNeeded => $_getBF(17);
  @$pb.TagNumber(18)
  set discussionNeeded($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasDiscussionNeeded() => $_has(17);
  @$pb.TagNumber(18)
  void clearDiscussionNeeded() => $_clearField(18);

  @$pb.TagNumber(19)
  EndgameClimbState get endgameClimbAllianceStation1 => $_getN(18);
  @$pb.TagNumber(19)
  set endgameClimbAllianceStation1(EndgameClimbState value) =>
      $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasEndgameClimbAllianceStation1() => $_has(18);
  @$pb.TagNumber(19)
  void clearEndgameClimbAllianceStation1() => $_clearField(19);

  @$pb.TagNumber(20)
  EndgameClimbState get endgameClimbAllianceStation2 => $_getN(19);
  @$pb.TagNumber(20)
  set endgameClimbAllianceStation2(EndgameClimbState value) =>
      $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasEndgameClimbAllianceStation2() => $_has(19);
  @$pb.TagNumber(20)
  void clearEndgameClimbAllianceStation2() => $_clearField(20);

  @$pb.TagNumber(21)
  EndgameClimbState get endgameClimbAllianceStation3 => $_getN(20);
  @$pb.TagNumber(21)
  set endgameClimbAllianceStation3(EndgameClimbState value) =>
      $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasEndgameClimbAllianceStation3() => $_has(20);
  @$pb.TagNumber(21)
  void clearEndgameClimbAllianceStation3() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.bool get endgameSubmitted => $_getBF(21);
  @$pb.TagNumber(22)
  set endgameSubmitted($core.bool value) => $_setBool(21, value);
  @$pb.TagNumber(22)
  $core.bool hasEndgameSubmitted() => $_has(21);
  @$pb.TagNumber(22)
  void clearEndgameSubmitted() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.bool get endgameIssue => $_getBF(22);
  @$pb.TagNumber(23)
  set endgameIssue($core.bool value) => $_setBool(22, value);
  @$pb.TagNumber(23)
  $core.bool hasEndgameIssue() => $_has(22);
  @$pb.TagNumber(23)
  void clearEndgameIssue() => $_clearField(23);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
