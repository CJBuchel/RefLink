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
      '1': 'alliance_station_1_team_number',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'allianceStation1TeamNumber'
    },
    {
      '1': 'alliance_station_2_team_number',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'allianceStation2TeamNumber'
    },
    {
      '1': 'alliance_station_3_team_number',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'allianceStation3TeamNumber'
    },
    {
      '1': 'partner_panel',
      '3': 6,
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
    'EkIKHmFsbGlhbmNlX3N0YXRpb25fMV90ZWFtX251bWJlchgDIAEoCVIaYWxsaWFuY2VTdGF0aW'
    '9uMVRlYW1OdW1iZXISQgoeYWxsaWFuY2Vfc3RhdGlvbl8yX3RlYW1fbnVtYmVyGAQgASgJUhph'
    'bGxpYW5jZVN0YXRpb24yVGVhbU51bWJlchJCCh5hbGxpYW5jZV9zdGF0aW9uXzNfdGVhbV9udW'
    '1iZXIYBSABKAlSGmFsbGlhbmNlU3RhdGlvbjNUZWFtTnVtYmVyEkYKDXBhcnRuZXJfcGFuZWwY'
    'BiABKAsyIS5yZWZsaW5rLmNvbW1vbi5SZWZlcmVlUGFuZWxTdGF0ZVIMcGFydG5lclBhbmVs');
