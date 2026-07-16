// This is a generated file - do not edit.
//
// Generated from fms.proto.

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

@$core.Deprecated('Use fmsTeamStateDescriptor instead')
const FmsTeamState$json = {
  '1': 'FmsTeamState',
  '2': [
    {
      '1': 'alliance_station',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.reflink.common.TeamAllianceStationType',
      '10': 'allianceStation'
    },
    {'1': 'team_number', '3': 2, '4': 1, '5': 5, '10': 'teamNumber'},
    {'1': 'bypassed', '3': 3, '4': 1, '5': 8, '10': 'bypassed'},
    {'1': 'estop', '3': 4, '4': 1, '5': 8, '10': 'estop'},
    {'1': 'astop', '3': 5, '4': 1, '5': 8, '10': 'astop'},
  ],
};

/// Descriptor for `FmsTeamState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fmsTeamStateDescriptor = $convert.base64Decode(
    'CgxGbXNUZWFtU3RhdGUSUgoQYWxsaWFuY2Vfc3RhdGlvbhgBIAEoDjInLnJlZmxpbmsuY29tbW'
    '9uLlRlYW1BbGxpYW5jZVN0YXRpb25UeXBlUg9hbGxpYW5jZVN0YXRpb24SHwoLdGVhbV9udW1i'
    'ZXIYAiABKAVSCnRlYW1OdW1iZXISGgoIYnlwYXNzZWQYAyABKAhSCGJ5cGFzc2VkEhQKBWVzdG'
    '9wGAQgASgIUgVlc3RvcBIUCgVhc3RvcBgFIAEoCFIFYXN0b3A=');

@$core.Deprecated('Use fmsMatchInfoDescriptor instead')
const FmsMatchInfo$json = {
  '1': 'FmsMatchInfo',
  '2': [
    {'1': 'match_id', '3': 1, '4': 1, '5': 5, '10': 'matchId'},
    {'1': 'match_number', '3': 2, '4': 1, '5': 5, '10': 'matchNumber'},
    {
      '1': 'match_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.reflink.common.MatchType',
      '10': 'matchType'
    },
    {
      '1': 'match_phase',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.reflink.common.MatchPhase',
      '10': 'matchPhase'
    },
    {
      '1': 'time_remaining_sec',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'timeRemainingSec'
    },
    {
      '1': 'teams',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.reflink.fms.FmsTeamState',
      '10': 'teams'
    },
    {
      '1': 'next_match_estimated_at_unix_sec',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'nextMatchEstimatedAtUnixSec'
    },
  ],
};

/// Descriptor for `FmsMatchInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fmsMatchInfoDescriptor = $convert.base64Decode(
    'CgxGbXNNYXRjaEluZm8SGQoIbWF0Y2hfaWQYASABKAVSB21hdGNoSWQSIQoMbWF0Y2hfbnVtYm'
    'VyGAIgASgFUgttYXRjaE51bWJlchI4CgptYXRjaF90eXBlGAMgASgOMhkucmVmbGluay5jb21t'
    'b24uTWF0Y2hUeXBlUgltYXRjaFR5cGUSOwoLbWF0Y2hfcGhhc2UYBCABKA4yGi5yZWZsaW5rLm'
    'NvbW1vbi5NYXRjaFBoYXNlUgptYXRjaFBoYXNlEiwKEnRpbWVfcmVtYWluaW5nX3NlYxgFIAEo'
    'BVIQdGltZVJlbWFpbmluZ1NlYxIvCgV0ZWFtcxgGIAMoCzIZLnJlZmxpbmsuZm1zLkZtc1RlYW'
    '1TdGF0ZVIFdGVhbXMSRQogbmV4dF9tYXRjaF9lc3RpbWF0ZWRfYXRfdW5peF9zZWMYByABKANS'
    'G25leHRNYXRjaEVzdGltYXRlZEF0VW5peFNlYw==');

@$core.Deprecated('Use fmsConnectionStatusDescriptor instead')
const FmsConnectionStatus$json = {
  '1': 'FmsConnectionStatus',
  '2': [
    {'1': 'connected', '3': 1, '4': 1, '5': 8, '10': 'connected'},
    {'1': 'host', '3': 2, '4': 1, '5': 9, '10': 'host'},
    {'1': 'port', '3': 3, '4': 1, '5': 5, '10': 'port'},
    {'1': 'last_error', '3': 4, '4': 1, '5': 9, '10': 'lastError'},
  ],
};

/// Descriptor for `FmsConnectionStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fmsConnectionStatusDescriptor = $convert.base64Decode(
    'ChNGbXNDb25uZWN0aW9uU3RhdHVzEhwKCWNvbm5lY3RlZBgBIAEoCFIJY29ubmVjdGVkEhIKBG'
    'hvc3QYAiABKAlSBGhvc3QSEgoEcG9ydBgDIAEoBVIEcG9ydBIdCgpsYXN0X2Vycm9yGAQgASgJ'
    'UglsYXN0RXJyb3I=');

@$core.Deprecated('Use getMatchInfoRequestDescriptor instead')
const GetMatchInfoRequest$json = {
  '1': 'GetMatchInfoRequest',
};

/// Descriptor for `GetMatchInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMatchInfoRequestDescriptor =
    $convert.base64Decode('ChNHZXRNYXRjaEluZm9SZXF1ZXN0');

@$core.Deprecated('Use streamMatchInfoRequestDescriptor instead')
const StreamMatchInfoRequest$json = {
  '1': 'StreamMatchInfoRequest',
};

/// Descriptor for `StreamMatchInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamMatchInfoRequestDescriptor =
    $convert.base64Decode('ChZTdHJlYW1NYXRjaEluZm9SZXF1ZXN0');

@$core.Deprecated('Use streamConnectionStatusRequestDescriptor instead')
const StreamConnectionStatusRequest$json = {
  '1': 'StreamConnectionStatusRequest',
};

/// Descriptor for `StreamConnectionStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamConnectionStatusRequestDescriptor =
    $convert.base64Decode('Ch1TdHJlYW1Db25uZWN0aW9uU3RhdHVzUmVxdWVzdA==');
