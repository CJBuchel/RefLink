// This is a generated file - do not edit.
//
// Generated from api.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use refereeVoteDescriptor instead')
const RefereeVote$json = {
  '1': 'RefereeVote',
  '2': [
    {'1': 'REFEREE_VOTE_UNSPECIFIED', '2': 0},
    {'1': 'REFEREE_VOTE_DISAGREE', '2': 1},
    {'1': 'REFEREE_VOTE_AGREE', '2': 2},
  ],
};

/// Descriptor for `RefereeVote`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List refereeVoteDescriptor = $convert.base64Decode(
    'CgtSZWZlcmVlVm90ZRIcChhSRUZFUkVFX1ZPVEVfVU5TUEVDSUZJRUQQABIZChVSRUZFUkVFX1'
    'ZPVEVfRElTQUdSRUUQARIWChJSRUZFUkVFX1ZPVEVfQUdSRUUQAg==');

@$core.Deprecated('Use matchPhaseDescriptor instead')
const MatchPhase$json = {
  '1': 'MatchPhase',
  '2': [
    {'1': 'MATCH_PHASE_IDLE_UNSPECIFIED', '2': 0},
    {'1': 'MATCH_PHASE_PRE_MATCH', '2': 1},
    {'1': 'MATCH_PHASE_AUTO', '2': 2},
    {'1': 'MATCH_PHASE_TELEOP', '2': 3},
    {'1': 'MATCH_PHASE_ENDGAME', '2': 4},
    {'1': 'MATCH_PHASE_POST_MATCH', '2': 5},
  ],
};

/// Descriptor for `MatchPhase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List matchPhaseDescriptor = $convert.base64Decode(
    'CgpNYXRjaFBoYXNlEiAKHE1BVENIX1BIQVNFX0lETEVfVU5TUEVDSUZJRUQQABIZChVNQVRDSF'
    '9QSEFTRV9QUkVfTUFUQ0gQARIUChBNQVRDSF9QSEFTRV9BVVRPEAISFgoSTUFUQ0hfUEhBU0Vf'
    'VEVMRU9QEAMSFwoTTUFUQ0hfUEhBU0VfRU5ER0FNRRAEEhoKFk1BVENIX1BIQVNFX1BPU1RfTU'
    'FUQ0gQBQ==');

@$core.Deprecated('Use refereeStreamRequestDescriptor instead')
const RefereeStreamRequest$json = {
  '1': 'RefereeStreamRequest',
  '2': [
    {'1': 'panel_id', '3': 1, '4': 1, '5': 5, '10': 'panelId'},
    {
      '1': 'referee_vote',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.reflink.api.RefereeVote',
      '10': 'refereeVote'
    },
  ],
};

/// Descriptor for `RefereeStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refereeStreamRequestDescriptor = $convert.base64Decode(
    'ChRSZWZlcmVlU3RyZWFtUmVxdWVzdBIZCghwYW5lbF9pZBgBIAEoBVIHcGFuZWxJZBI7CgxyZW'
    'ZlcmVlX3ZvdGUYAiABKA4yGC5yZWZsaW5rLmFwaS5SZWZlcmVlVm90ZVILcmVmZXJlZVZvdGU=');

@$core.Deprecated('Use refereeStreamResponseDescriptor instead')
const RefereeStreamResponse$json = {
  '1': 'RefereeStreamResponse',
  '2': [
    {'1': 'match_id', '3': 1, '4': 1, '5': 5, '10': 'matchId'},
    {
      '1': 'match_phase',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.reflink.api.MatchPhase',
      '10': 'matchPhase'
    },
  ],
};

/// Descriptor for `RefereeStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refereeStreamResponseDescriptor = $convert.base64Decode(
    'ChVSZWZlcmVlU3RyZWFtUmVzcG9uc2USGQoIbWF0Y2hfaWQYASABKAVSB21hdGNoSWQSOAoLbW'
    'F0Y2hfcGhhc2UYAiABKA4yFy5yZWZsaW5rLmFwaS5NYXRjaFBoYXNlUgptYXRjaFBoYXNl');
