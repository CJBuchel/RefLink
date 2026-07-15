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

class TeamAllianceStationType extends $pb.ProtobufEnum {
  static const TeamAllianceStationType TEAM_ALLIANCE_STATION_TYPE_UNSPECIFIED =
      TeamAllianceStationType._(
          0, _omitEnumNames ? '' : 'TEAM_ALLIANCE_STATION_TYPE_UNSPECIFIED');
  static const TeamAllianceStationType TEAM_ALLIANCE_STATION_TYPE_RED_1 =
      TeamAllianceStationType._(
          1, _omitEnumNames ? '' : 'TEAM_ALLIANCE_STATION_TYPE_RED_1');
  static const TeamAllianceStationType TEAM_ALLIANCE_STATION_TYPE_RED_2 =
      TeamAllianceStationType._(
          2, _omitEnumNames ? '' : 'TEAM_ALLIANCE_STATION_TYPE_RED_2');
  static const TeamAllianceStationType TEAM_ALLIANCE_STATION_TYPE_RED_3 =
      TeamAllianceStationType._(
          3, _omitEnumNames ? '' : 'TEAM_ALLIANCE_STATION_TYPE_RED_3');
  static const TeamAllianceStationType TEAM_ALLIANCE_STATION_TYPE_BLUE_1 =
      TeamAllianceStationType._(
          4, _omitEnumNames ? '' : 'TEAM_ALLIANCE_STATION_TYPE_BLUE_1');
  static const TeamAllianceStationType TEAM_ALLIANCE_STATION_TYPE_BLUE_2 =
      TeamAllianceStationType._(
          5, _omitEnumNames ? '' : 'TEAM_ALLIANCE_STATION_TYPE_BLUE_2');
  static const TeamAllianceStationType TEAM_ALLIANCE_STATION_TYPE_BLUE_3 =
      TeamAllianceStationType._(
          6, _omitEnumNames ? '' : 'TEAM_ALLIANCE_STATION_TYPE_BLUE_3');

  static const $core.List<TeamAllianceStationType> values =
      <TeamAllianceStationType>[
    TEAM_ALLIANCE_STATION_TYPE_UNSPECIFIED,
    TEAM_ALLIANCE_STATION_TYPE_RED_1,
    TEAM_ALLIANCE_STATION_TYPE_RED_2,
    TEAM_ALLIANCE_STATION_TYPE_RED_3,
    TEAM_ALLIANCE_STATION_TYPE_BLUE_1,
    TEAM_ALLIANCE_STATION_TYPE_BLUE_2,
    TEAM_ALLIANCE_STATION_TYPE_BLUE_3,
  ];

  static final $core.List<TeamAllianceStationType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static TeamAllianceStationType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TeamAllianceStationType._(super.value, super.name);
}

class PanelType extends $pb.ProtobufEnum {
  static const PanelType PANEL_TYPE_UNSPECIFIED =
      PanelType._(0, _omitEnumNames ? '' : 'PANEL_TYPE_UNSPECIFIED');
  static const PanelType PANEL_TYPE_HEAD_REFEREE =
      PanelType._(1, _omitEnumNames ? '' : 'PANEL_TYPE_HEAD_REFEREE');
  static const PanelType PANEL_TYPE_RED_NEAR =
      PanelType._(2, _omitEnumNames ? '' : 'PANEL_TYPE_RED_NEAR');
  static const PanelType PANEL_TYPE_RED_FAR =
      PanelType._(3, _omitEnumNames ? '' : 'PANEL_TYPE_RED_FAR');
  static const PanelType PANEL_TYPE_BLUE_NEAR =
      PanelType._(4, _omitEnumNames ? '' : 'PANEL_TYPE_BLUE_NEAR');
  static const PanelType PANEL_TYPE_BLUE_FAR =
      PanelType._(5, _omitEnumNames ? '' : 'PANEL_TYPE_BLUE_FAR');

  static const $core.List<PanelType> values = <PanelType>[
    PANEL_TYPE_UNSPECIFIED,
    PANEL_TYPE_HEAD_REFEREE,
    PANEL_TYPE_RED_NEAR,
    PANEL_TYPE_RED_FAR,
    PANEL_TYPE_BLUE_NEAR,
    PANEL_TYPE_BLUE_FAR,
  ];

  static final $core.List<PanelType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PanelType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PanelType._(super.value, super.name);
}

class RefereeVote extends $pb.ProtobufEnum {
  static const RefereeVote REFEREE_VOTE_UNSPECIFIED =
      RefereeVote._(0, _omitEnumNames ? '' : 'REFEREE_VOTE_UNSPECIFIED');
  static const RefereeVote REFEREE_VOTE_DISAGREE =
      RefereeVote._(1, _omitEnumNames ? '' : 'REFEREE_VOTE_DISAGREE');
  static const RefereeVote REFEREE_VOTE_AGREE =
      RefereeVote._(2, _omitEnumNames ? '' : 'REFEREE_VOTE_AGREE');

  static const $core.List<RefereeVote> values = <RefereeVote>[
    REFEREE_VOTE_UNSPECIFIED,
    REFEREE_VOTE_DISAGREE,
    REFEREE_VOTE_AGREE,
  ];

  static final $core.List<RefereeVote?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RefereeVote? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RefereeVote._(super.value, super.name);
}

class AutoClimbState extends $pb.ProtobufEnum {
  static const AutoClimbState AUTO_CLIMB_STATE_UNSPECIFIED =
      AutoClimbState._(0, _omitEnumNames ? '' : 'AUTO_CLIMB_STATE_UNSPECIFIED');
  static const AutoClimbState AUTO_CLIMB_STATE_NOTHING =
      AutoClimbState._(1, _omitEnumNames ? '' : 'AUTO_CLIMB_STATE_NOTHING');
  static const AutoClimbState AUTO_CLIMB_STATE_LEVEL_1 =
      AutoClimbState._(2, _omitEnumNames ? '' : 'AUTO_CLIMB_STATE_LEVEL_1');

  static const $core.List<AutoClimbState> values = <AutoClimbState>[
    AUTO_CLIMB_STATE_UNSPECIFIED,
    AUTO_CLIMB_STATE_NOTHING,
    AUTO_CLIMB_STATE_LEVEL_1,
  ];

  static final $core.List<AutoClimbState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AutoClimbState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AutoClimbState._(super.value, super.name);
}

class CardType extends $pb.ProtobufEnum {
  static const CardType CARD_TYPE_UNSPECIFIED =
      CardType._(0, _omitEnumNames ? '' : 'CARD_TYPE_UNSPECIFIED');
  static const CardType CARD_TYPE_YELLOW =
      CardType._(1, _omitEnumNames ? '' : 'CARD_TYPE_YELLOW');
  static const CardType CARD_TYPE_RED =
      CardType._(2, _omitEnumNames ? '' : 'CARD_TYPE_RED');

  static const $core.List<CardType> values = <CardType>[
    CARD_TYPE_UNSPECIFIED,
    CARD_TYPE_YELLOW,
    CARD_TYPE_RED,
  ];

  static final $core.List<CardType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static CardType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CardType._(super.value, super.name);
}

class EndgameClimbState extends $pb.ProtobufEnum {
  static const EndgameClimbState ENDGAME_CLIMB_STATE_UNSPECIFIED =
      EndgameClimbState._(
          0, _omitEnumNames ? '' : 'ENDGAME_CLIMB_STATE_UNSPECIFIED');
  static const EndgameClimbState ENDGAME_CLIMB_STATE_NOTHING =
      EndgameClimbState._(
          1, _omitEnumNames ? '' : 'ENDGAME_CLIMB_STATE_NOTHING');
  static const EndgameClimbState ENDGAME_CLIMB_STATE_LEVEL_1 =
      EndgameClimbState._(
          2, _omitEnumNames ? '' : 'ENDGAME_CLIMB_STATE_LEVEL_1');
  static const EndgameClimbState ENDGAME_CLIMB_STATE_LEVEL_2 =
      EndgameClimbState._(
          3, _omitEnumNames ? '' : 'ENDGAME_CLIMB_STATE_LEVEL_2');
  static const EndgameClimbState ENDGAME_CLIMB_STATE_LEVEL_3 =
      EndgameClimbState._(
          4, _omitEnumNames ? '' : 'ENDGAME_CLIMB_STATE_LEVEL_3');

  static const $core.List<EndgameClimbState> values = <EndgameClimbState>[
    ENDGAME_CLIMB_STATE_UNSPECIFIED,
    ENDGAME_CLIMB_STATE_NOTHING,
    ENDGAME_CLIMB_STATE_LEVEL_1,
    ENDGAME_CLIMB_STATE_LEVEL_2,
    ENDGAME_CLIMB_STATE_LEVEL_3,
  ];

  static final $core.List<EndgameClimbState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EndgameClimbState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EndgameClimbState._(super.value, super.name);
}

class MatchPhase extends $pb.ProtobufEnum {
  static const MatchPhase MATCH_PHASE_IDLE_UNSPECIFIED =
      MatchPhase._(0, _omitEnumNames ? '' : 'MATCH_PHASE_IDLE_UNSPECIFIED');
  static const MatchPhase MATCH_PHASE_PRE_MATCH =
      MatchPhase._(1, _omitEnumNames ? '' : 'MATCH_PHASE_PRE_MATCH');
  static const MatchPhase MATCH_PHASE_AUTO =
      MatchPhase._(2, _omitEnumNames ? '' : 'MATCH_PHASE_AUTO');
  static const MatchPhase MATCH_PHASE_TELEOP =
      MatchPhase._(3, _omitEnumNames ? '' : 'MATCH_PHASE_TELEOP');
  static const MatchPhase MATCH_PHASE_ENDGAME =
      MatchPhase._(4, _omitEnumNames ? '' : 'MATCH_PHASE_ENDGAME');
  static const MatchPhase MATCH_PHASE_POST_MATCH =
      MatchPhase._(5, _omitEnumNames ? '' : 'MATCH_PHASE_POST_MATCH');

  static const $core.List<MatchPhase> values = <MatchPhase>[
    MATCH_PHASE_IDLE_UNSPECIFIED,
    MATCH_PHASE_PRE_MATCH,
    MATCH_PHASE_AUTO,
    MATCH_PHASE_TELEOP,
    MATCH_PHASE_ENDGAME,
    MATCH_PHASE_POST_MATCH,
  ];

  static final $core.List<MatchPhase?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static MatchPhase? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MatchPhase._(super.value, super.name);
}

class MatchType extends $pb.ProtobufEnum {
  static const MatchType MATCH_TYPE_UNSPECIFIED =
      MatchType._(0, _omitEnumNames ? '' : 'MATCH_TYPE_UNSPECIFIED');
  static const MatchType MATCH_TYPE_PRACTICE =
      MatchType._(1, _omitEnumNames ? '' : 'MATCH_TYPE_PRACTICE');
  static const MatchType MATCH_TYPE_QUALIFICATION =
      MatchType._(2, _omitEnumNames ? '' : 'MATCH_TYPE_QUALIFICATION');
  static const MatchType MATCH_TYPE_PLAYOFF =
      MatchType._(3, _omitEnumNames ? '' : 'MATCH_TYPE_PLAYOFF');

  static const $core.List<MatchType> values = <MatchType>[
    MATCH_TYPE_UNSPECIFIED,
    MATCH_TYPE_PRACTICE,
    MATCH_TYPE_QUALIFICATION,
    MATCH_TYPE_PLAYOFF,
  ];

  static final $core.List<MatchType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MatchType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MatchType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
