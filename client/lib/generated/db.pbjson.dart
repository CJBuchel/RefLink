// This is a generated file - do not edit.
//
// Generated from db.proto.

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

@$core.Deprecated('Use matchStateRecordDescriptor instead')
const MatchStateRecord$json = {
  '1': 'MatchStateRecord',
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
      '1': 'rn',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'rn'
    },
    {
      '1': 'rf',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'rf'
    },
    {
      '1': 'bn',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'bn'
    },
    {
      '1': 'bf',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.reflink.common.RefereePanelState',
      '10': 'bf'
    },
  ],
};

/// Descriptor for `MatchStateRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchStateRecordDescriptor = $convert.base64Decode(
    'ChBNYXRjaFN0YXRlUmVjb3JkEhkKCG1hdGNoX2lkGAEgASgFUgdtYXRjaElkEjsKC21hdGNoX3'
    'BoYXNlGAIgASgOMhoucmVmbGluay5jb21tb24uTWF0Y2hQaGFzZVIKbWF0Y2hQaGFzZRIxCgJy'
    'bhgEIAEoCzIhLnJlZmxpbmsuY29tbW9uLlJlZmVyZWVQYW5lbFN0YXRlUgJybhIxCgJyZhgFIA'
    'EoCzIhLnJlZmxpbmsuY29tbW9uLlJlZmVyZWVQYW5lbFN0YXRlUgJyZhIxCgJibhgGIAEoCzIh'
    'LnJlZmxpbmsuY29tbW9uLlJlZmVyZWVQYW5lbFN0YXRlUgJibhIxCgJiZhgHIAEoCzIhLnJlZm'
    'xpbmsuY29tbW9uLlJlZmVyZWVQYW5lbFN0YXRlUgJiZg==');
