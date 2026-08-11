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

@$core.Deprecated('Use refereeStreamRequestDescriptor instead')
const RefereeStreamRequest$json = {
  '1': 'RefereeStreamRequest',
  '2': [
    {
      '1': 'panel',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.reflink.common.PanelType',
      '10': 'panel'
    },
    {'1': 'match_id', '3': 2, '4': 1, '5': 5, '10': 'matchId'},
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `RefereeStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refereeStreamRequestDescriptor = $convert.base64Decode(
    'ChRSZWZlcmVlU3RyZWFtUmVxdWVzdBIvCgVwYW5lbBgBIAEoDjIZLnJlZmxpbmsuY29tbW9uLl'
    'BhbmVsVHlwZVIFcGFuZWwSGQoIbWF0Y2hfaWQYAiABKAVSB21hdGNoSWQSNwoFc3RhdGUYAyAB'
    'KAsyIS5yZWZsaW5rLmNvbW1vbi5SZWZlcmVlUGFuZWxTdGF0ZVIFc3RhdGU=');

@$core.Deprecated('Use matchStationStateDescriptor instead')
const MatchStationState$json = {
  '1': 'MatchStationState',
  '2': [
    {'1': 'team_number', '3': 1, '4': 1, '5': 9, '10': 'teamNumber'},
    {'1': 'bypassed', '3': 2, '4': 1, '5': 8, '10': 'bypassed'},
    {
      '1': 'alliance_station',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.reflink.common.TeamAllianceStationType',
      '10': 'allianceStation'
    },
  ],
};

/// Descriptor for `MatchStationState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchStationStateDescriptor = $convert.base64Decode(
    'ChFNYXRjaFN0YXRpb25TdGF0ZRIfCgt0ZWFtX251bWJlchgBIAEoCVIKdGVhbU51bWJlchIaCg'
    'hieXBhc3NlZBgCIAEoCFIIYnlwYXNzZWQSUgoQYWxsaWFuY2Vfc3RhdGlvbhgDIAEoDjInLnJl'
    'ZmxpbmsuY29tbW9uLlRlYW1BbGxpYW5jZVN0YXRpb25UeXBlUg9hbGxpYW5jZVN0YXRpb24=');

@$core.Deprecated('Use matchAllianceStateDescriptor instead')
const MatchAllianceState$json = {
  '1': 'MatchAllianceState',
  '2': [
    {
      '1': 'alliance_team_1_state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.MatchStationState',
      '10': 'allianceTeam1State'
    },
    {
      '1': 'alliance_team_2_state',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.MatchStationState',
      '10': 'allianceTeam2State'
    },
    {
      '1': 'alliance_team_3_state',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.MatchStationState',
      '10': 'allianceTeam3State'
    },
  ],
};

/// Descriptor for `MatchAllianceState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchAllianceStateDescriptor = $convert.base64Decode(
    'ChJNYXRjaEFsbGlhbmNlU3RhdGUSUQoVYWxsaWFuY2VfdGVhbV8xX3N0YXRlGAEgASgLMh4ucm'
    'VmbGluay5hcGkuTWF0Y2hTdGF0aW9uU3RhdGVSEmFsbGlhbmNlVGVhbTFTdGF0ZRJRChVhbGxp'
    'YW5jZV90ZWFtXzJfc3RhdGUYAiABKAsyHi5yZWZsaW5rLmFwaS5NYXRjaFN0YXRpb25TdGF0ZV'
    'ISYWxsaWFuY2VUZWFtMlN0YXRlElEKFWFsbGlhbmNlX3RlYW1fM19zdGF0ZRgDIAEoCzIeLnJl'
    'ZmxpbmsuYXBpLk1hdGNoU3RhdGlvblN0YXRlUhJhbGxpYW5jZVRlYW0zU3RhdGU=');

@$core.Deprecated('Use headRefereeStreamRequestDescriptor instead')
const HeadRefereeStreamRequest$json = {
  '1': 'HeadRefereeStreamRequest',
  '2': [
    {'1': 'match_id', '3': 1, '4': 1, '5': 5, '10': 'matchId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.HeadRefereePanelState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `HeadRefereeStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List headRefereeStreamRequestDescriptor = $convert.base64Decode(
    'ChhIZWFkUmVmZXJlZVN0cmVhbVJlcXVlc3QSGQoIbWF0Y2hfaWQYASABKAVSB21hdGNoSWQSOw'
    'oFc3RhdGUYAiABKAsyJS5yZWZsaW5rLmNvbW1vbi5IZWFkUmVmZXJlZVBhbmVsU3RhdGVSBXN0'
    'YXRl');

@$core.Deprecated('Use headRefereeStreamResponseDescriptor instead')
const HeadRefereeStreamResponse$json = {
  '1': 'HeadRefereeStreamResponse',
  '2': [
    {'1': 'match_id', '3': 1, '4': 1, '5': 5, '10': 'matchId'},
    {
      '1': 'match_phase',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.reflink.common.MatchPhase',
      '10': 'matchPhase'
    },
    {
      '1': 'red_alliance_state',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.MatchAllianceState',
      '10': 'redAllianceState'
    },
    {
      '1': 'blue_alliance_state',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.MatchAllianceState',
      '10': 'blueAllianceState'
    },
    {
      '1': 'rn',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'rn'
    },
    {
      '1': 'rf',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'rf'
    },
    {
      '1': 'bn',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'bn'
    },
    {
      '1': 'bf',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'bf'
    },
    {'1': 'rotate_in', '3': 10, '4': 1, '5': 5, '10': 'rotateIn'},
    {
      '1': 'hr',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.HeadRefereePanelState',
      '10': 'hr'
    },
  ],
};

/// Descriptor for `HeadRefereeStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List headRefereeStreamResponseDescriptor = $convert.base64Decode(
    'ChlIZWFkUmVmZXJlZVN0cmVhbVJlc3BvbnNlEhkKCG1hdGNoX2lkGAEgASgFUgdtYXRjaElkEj'
    'sKC21hdGNoX3BoYXNlGAIgASgOMhoucmVmbGluay5jb21tb24uTWF0Y2hQaGFzZVIKbWF0Y2hQ'
    'aGFzZRJNChJyZWRfYWxsaWFuY2Vfc3RhdGUYAyABKAsyHy5yZWZsaW5rLmFwaS5NYXRjaEFsbG'
    'lhbmNlU3RhdGVSEHJlZEFsbGlhbmNlU3RhdGUSTwoTYmx1ZV9hbGxpYW5jZV9zdGF0ZRgEIAEo'
    'CzIfLnJlZmxpbmsuYXBpLk1hdGNoQWxsaWFuY2VTdGF0ZVIRYmx1ZUFsbGlhbmNlU3RhdGUSMQ'
    'oCcm4YBSABKAsyIS5yZWZsaW5rLmNvbW1vbi5SZWZlcmVlUGFuZWxTdGF0ZVICcm4SMQoCcmYY'
    'BiABKAsyIS5yZWZsaW5rLmNvbW1vbi5SZWZlcmVlUGFuZWxTdGF0ZVICcmYSMQoCYm4YByABKA'
    'syIS5yZWZsaW5rLmNvbW1vbi5SZWZlcmVlUGFuZWxTdGF0ZVICYm4SMQoCYmYYCCABKAsyIS5y'
    'ZWZsaW5rLmNvbW1vbi5SZWZlcmVlUGFuZWxTdGF0ZVICYmYSGwoJcm90YXRlX2luGAogASgFUg'
    'hyb3RhdGVJbhI1CgJochgMIAEoCzIlLnJlZmxpbmsuY29tbW9uLkhlYWRSZWZlcmVlUGFuZWxT'
    'dGF0ZVICaHI=');

@$core.Deprecated('Use toggleBypassRequestDescriptor instead')
const ToggleBypassRequest$json = {
  '1': 'ToggleBypassRequest',
  '2': [
    {
      '1': 'station',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.reflink.common.TeamAllianceStationType',
      '10': 'station'
    },
  ],
};

/// Descriptor for `ToggleBypassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleBypassRequestDescriptor = $convert.base64Decode(
    'ChNUb2dnbGVCeXBhc3NSZXF1ZXN0EkEKB3N0YXRpb24YASABKA4yJy5yZWZsaW5rLmNvbW1vbi'
    '5UZWFtQWxsaWFuY2VTdGF0aW9uVHlwZVIHc3RhdGlvbg==');

@$core.Deprecated('Use toggleBypassResponseDescriptor instead')
const ToggleBypassResponse$json = {
  '1': 'ToggleBypassResponse',
};

/// Descriptor for `ToggleBypassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleBypassResponseDescriptor =
    $convert.base64Decode('ChRUb2dnbGVCeXBhc3NSZXNwb25zZQ==');

@$core.Deprecated('Use commitAndPostRequestDescriptor instead')
const CommitAndPostRequest$json = {
  '1': 'CommitAndPostRequest',
};

/// Descriptor for `CommitAndPostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commitAndPostRequestDescriptor =
    $convert.base64Decode('ChRDb21taXRBbmRQb3N0UmVxdWVzdA==');

@$core.Deprecated('Use commitAndPostResponseDescriptor instead')
const CommitAndPostResponse$json = {
  '1': 'CommitAndPostResponse',
};

/// Descriptor for `CommitAndPostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commitAndPostResponseDescriptor =
    $convert.base64Decode('ChVDb21taXRBbmRQb3N0UmVzcG9uc2U=');
