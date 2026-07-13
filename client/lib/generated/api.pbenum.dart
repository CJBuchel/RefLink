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

/// ----- Client -> Server -----
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

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
