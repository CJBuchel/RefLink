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

@$core.Deprecated('Use getHealthRequestDescriptor instead')
const GetHealthRequest$json = {
  '1': 'GetHealthRequest',
};

/// Descriptor for `GetHealthRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthRequestDescriptor =
    $convert.base64Decode('ChBHZXRIZWFsdGhSZXF1ZXN0');

@$core.Deprecated('Use getHealthResponseDescriptor instead')
const GetHealthResponse$json = {
  '1': 'GetHealthResponse',
};

/// Descriptor for `GetHealthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthResponseDescriptor =
    $convert.base64Decode('ChFHZXRIZWFsdGhSZXNwb25zZQ==');

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

@$core.Deprecated('Use refereeTeamStateDescriptor instead')
const RefereeTeamState$json = {
  '1': 'RefereeTeamState',
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

/// Descriptor for `RefereeTeamState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refereeTeamStateDescriptor = $convert.base64Decode(
    'ChBSZWZlcmVlVGVhbVN0YXRlEh8KC3RlYW1fbnVtYmVyGAEgASgJUgp0ZWFtTnVtYmVyEhoKCG'
    'J5cGFzc2VkGAIgASgIUghieXBhc3NlZBJSChBhbGxpYW5jZV9zdGF0aW9uGAMgASgOMicucmVm'
    'bGluay5jb21tb24uVGVhbUFsbGlhbmNlU3RhdGlvblR5cGVSD2FsbGlhbmNlU3RhdGlvbg==');

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
      '6': '.reflink.common.MatchPhase',
      '10': 'matchPhase'
    },
    {
      '1': 'red_alliance_team_1_state',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.RefereeTeamState',
      '10': 'redAllianceTeam1State'
    },
    {
      '1': 'red_alliance_team_2_state',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.RefereeTeamState',
      '10': 'redAllianceTeam2State'
    },
    {
      '1': 'red_alliance_team_3_state',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.RefereeTeamState',
      '10': 'redAllianceTeam3State'
    },
    {
      '1': 'blue_alliance_team_1_state',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.RefereeTeamState',
      '10': 'blueAllianceTeam1State'
    },
    {
      '1': 'blue_alliance_team_2_state',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.RefereeTeamState',
      '10': 'blueAllianceTeam2State'
    },
    {
      '1': 'blue_alliance_team_3_state',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.reflink.api.RefereeTeamState',
      '10': 'blueAllianceTeam3State'
    },
    {
      '1': 'partner_panel',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'partnerPanel'
    },
  ],
};

/// Descriptor for `RefereeStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refereeStreamResponseDescriptor = $convert.base64Decode(
    'ChVSZWZlcmVlU3RyZWFtUmVzcG9uc2USGQoIbWF0Y2hfaWQYASABKAVSB21hdGNoSWQSOwoLbW'
    'F0Y2hfcGhhc2UYAiABKA4yGi5yZWZsaW5rLmNvbW1vbi5NYXRjaFBoYXNlUgptYXRjaFBoYXNl'
    'ElcKGXJlZF9hbGxpYW5jZV90ZWFtXzFfc3RhdGUYAyABKAsyHS5yZWZsaW5rLmFwaS5SZWZlcm'
    'VlVGVhbVN0YXRlUhVyZWRBbGxpYW5jZVRlYW0xU3RhdGUSVwoZcmVkX2FsbGlhbmNlX3RlYW1f'
    'Ml9zdGF0ZRgEIAEoCzIdLnJlZmxpbmsuYXBpLlJlZmVyZWVUZWFtU3RhdGVSFXJlZEFsbGlhbm'
    'NlVGVhbTJTdGF0ZRJXChlyZWRfYWxsaWFuY2VfdGVhbV8zX3N0YXRlGAUgASgLMh0ucmVmbGlu'
    'ay5hcGkuUmVmZXJlZVRlYW1TdGF0ZVIVcmVkQWxsaWFuY2VUZWFtM1N0YXRlElkKGmJsdWVfYW'
    'xsaWFuY2VfdGVhbV8xX3N0YXRlGAYgASgLMh0ucmVmbGluay5hcGkuUmVmZXJlZVRlYW1TdGF0'
    'ZVIWYmx1ZUFsbGlhbmNlVGVhbTFTdGF0ZRJZChpibHVlX2FsbGlhbmNlX3RlYW1fMl9zdGF0ZR'
    'gHIAEoCzIdLnJlZmxpbmsuYXBpLlJlZmVyZWVUZWFtU3RhdGVSFmJsdWVBbGxpYW5jZVRlYW0y'
    'U3RhdGUSWQoaYmx1ZV9hbGxpYW5jZV90ZWFtXzNfc3RhdGUYCCABKAsyHS5yZWZsaW5rLmFwaS'
    '5SZWZlcmVlVGVhbVN0YXRlUhZibHVlQWxsaWFuY2VUZWFtM1N0YXRlEkYKDXBhcnRuZXJfcGFu'
    'ZWwYCSABKAsyIS5yZWZsaW5rLmNvbW1vbi5SZWZlcmVlUGFuZWxTdGF0ZVIMcGFydG5lclBhbm'
    'Vs');
