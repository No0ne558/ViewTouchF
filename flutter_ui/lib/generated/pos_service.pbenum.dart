// This is a generated file - do not edit.
//
// Generated from pos_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ModifierAction extends $pb.ProtobufEnum {
  static const ModifierAction MOD_NONE =
      ModifierAction._(0, _omitEnumNames ? '' : 'MOD_NONE');
  static const ModifierAction MOD_NO =
      ModifierAction._(1, _omitEnumNames ? '' : 'MOD_NO');
  static const ModifierAction MOD_ADD =
      ModifierAction._(2, _omitEnumNames ? '' : 'MOD_ADD');
  static const ModifierAction MOD_EXTRA =
      ModifierAction._(3, _omitEnumNames ? '' : 'MOD_EXTRA');
  static const ModifierAction MOD_LIGHT =
      ModifierAction._(4, _omitEnumNames ? '' : 'MOD_LIGHT');
  static const ModifierAction MOD_SIDE =
      ModifierAction._(5, _omitEnumNames ? '' : 'MOD_SIDE');
  static const ModifierAction MOD_DOUBLE =
      ModifierAction._(6, _omitEnumNames ? '' : 'MOD_DOUBLE');

  static const $core.List<ModifierAction> values = <ModifierAction>[
    MOD_NONE,
    MOD_NO,
    MOD_ADD,
    MOD_EXTRA,
    MOD_LIGHT,
    MOD_SIDE,
    MOD_DOUBLE,
  ];

  static final $core.List<ModifierAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ModifierAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ModifierAction._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
