// This is a generated file - do not edit.
//
// Generated from proto/pos_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'pos_service.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'pos_service.pbenum.dart';

class Modifier extends $pb.GeneratedMessage {
  factory Modifier({
    $core.String? id,
    $core.String? name,
    $core.int? priceCents,
    $core.bool? isDefault,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (priceCents != null) result.priceCents = priceCents;
    if (isDefault != null) result.isDefault = isDefault;
    return result;
  }

  Modifier._();

  factory Modifier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Modifier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Modifier',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'priceCents')
    ..aOB(4, _omitFieldNames ? '' : 'isDefault')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Modifier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Modifier copyWith(void Function(Modifier) updates) =>
      super.copyWith((message) => updates(message as Modifier)) as Modifier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Modifier create() => Modifier._();
  @$core.override
  Modifier createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Modifier getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Modifier>(create);
  static Modifier? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get priceCents => $_getIZ(2);
  @$pb.TagNumber(3)
  set priceCents($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPriceCents() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriceCents() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isDefault => $_getBF(3);
  @$pb.TagNumber(4)
  set isDefault($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsDefault() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsDefault() => $_clearField(4);
}

class ModifierGroup extends $pb.GeneratedMessage {
  factory ModifierGroup({
    $core.String? id,
    $core.String? name,
    $core.Iterable<Modifier>? modifiers,
    $core.int? minSelect,
    $core.int? maxSelect,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (modifiers != null) result.modifiers.addAll(modifiers);
    if (minSelect != null) result.minSelect = minSelect;
    if (maxSelect != null) result.maxSelect = maxSelect;
    return result;
  }

  ModifierGroup._();

  factory ModifierGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ModifierGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModifierGroup',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pPM<Modifier>(3, _omitFieldNames ? '' : 'modifiers',
        subBuilder: Modifier.create)
    ..aI(4, _omitFieldNames ? '' : 'minSelect')
    ..aI(5, _omitFieldNames ? '' : 'maxSelect')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModifierGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModifierGroup copyWith(void Function(ModifierGroup) updates) =>
      super.copyWith((message) => updates(message as ModifierGroup))
          as ModifierGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModifierGroup create() => ModifierGroup._();
  @$core.override
  ModifierGroup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ModifierGroup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModifierGroup>(create);
  static ModifierGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Modifier> get modifiers => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get minSelect => $_getIZ(3);
  @$pb.TagNumber(4)
  set minSelect($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinSelect() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinSelect() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxSelect => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxSelect($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxSelect() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxSelect() => $_clearField(5);
}

class AppliedModifier extends $pb.GeneratedMessage {
  factory AppliedModifier({
    $core.String? modifierId,
    $core.String? modifierName,
    ModifierAction? action,
    $core.int? priceAdjustmentCents,
  }) {
    final result = create();
    if (modifierId != null) result.modifierId = modifierId;
    if (modifierName != null) result.modifierName = modifierName;
    if (action != null) result.action = action;
    if (priceAdjustmentCents != null)
      result.priceAdjustmentCents = priceAdjustmentCents;
    return result;
  }

  AppliedModifier._();

  factory AppliedModifier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppliedModifier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppliedModifier',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'modifierId')
    ..aOS(2, _omitFieldNames ? '' : 'modifierName')
    ..aE<ModifierAction>(3, _omitFieldNames ? '' : 'action',
        enumValues: ModifierAction.values)
    ..aI(4, _omitFieldNames ? '' : 'priceAdjustmentCents')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppliedModifier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppliedModifier copyWith(void Function(AppliedModifier) updates) =>
      super.copyWith((message) => updates(message as AppliedModifier))
          as AppliedModifier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppliedModifier create() => AppliedModifier._();
  @$core.override
  AppliedModifier createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppliedModifier getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppliedModifier>(create);
  static AppliedModifier? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get modifierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set modifierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModifierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearModifierId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get modifierName => $_getSZ(1);
  @$pb.TagNumber(2)
  set modifierName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModifierName() => $_has(1);
  @$pb.TagNumber(2)
  void clearModifierName() => $_clearField(2);

  @$pb.TagNumber(3)
  ModifierAction get action => $_getN(2);
  @$pb.TagNumber(3)
  set action(ModifierAction value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get priceAdjustmentCents => $_getIZ(3);
  @$pb.TagNumber(4)
  set priceAdjustmentCents($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPriceAdjustmentCents() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriceAdjustmentCents() => $_clearField(4);
}

class MenuItem extends $pb.GeneratedMessage {
  factory MenuItem({
    $core.String? id,
    $core.String? name,
    $core.int? priceCents,
    $core.String? category,
    $core.Iterable<ModifierGroup>? modifierGroups,
    $core.bool? sendToKitchen,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (priceCents != null) result.priceCents = priceCents;
    if (category != null) result.category = category;
    if (modifierGroups != null) result.modifierGroups.addAll(modifierGroups);
    if (sendToKitchen != null) result.sendToKitchen = sendToKitchen;
    return result;
  }

  MenuItem._();

  factory MenuItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'priceCents')
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..pPM<ModifierGroup>(5, _omitFieldNames ? '' : 'modifierGroups',
        subBuilder: ModifierGroup.create)
    ..aOB(6, _omitFieldNames ? '' : 'sendToKitchen')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuItem copyWith(void Function(MenuItem) updates) =>
      super.copyWith((message) => updates(message as MenuItem)) as MenuItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuItem create() => MenuItem._();
  @$core.override
  MenuItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MenuItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MenuItem>(create);
  static MenuItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get priceCents => $_getIZ(2);
  @$pb.TagNumber(3)
  set priceCents($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPriceCents() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriceCents() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ModifierGroup> get modifierGroups => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get sendToKitchen => $_getBF(5);
  @$pb.TagNumber(6)
  set sendToKitchen($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSendToKitchen() => $_has(5);
  @$pb.TagNumber(6)
  void clearSendToKitchen() => $_clearField(6);
}

class TicketItem extends $pb.GeneratedMessage {
  factory TicketItem({
    MenuItem? item,
    $core.int? quantity,
    $core.String? lineKey,
    $core.Iterable<AppliedModifier>? modifiers,
    $core.String? specialInstructions,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (quantity != null) result.quantity = quantity;
    if (lineKey != null) result.lineKey = lineKey;
    if (modifiers != null) result.modifiers.addAll(modifiers);
    if (specialInstructions != null)
      result.specialInstructions = specialInstructions;
    return result;
  }

  TicketItem._();

  factory TicketItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TicketItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TicketItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<MenuItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: MenuItem.create)
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..aOS(3, _omitFieldNames ? '' : 'lineKey')
    ..pPM<AppliedModifier>(4, _omitFieldNames ? '' : 'modifiers',
        subBuilder: AppliedModifier.create)
    ..aOS(5, _omitFieldNames ? '' : 'specialInstructions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TicketItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TicketItem copyWith(void Function(TicketItem) updates) =>
      super.copyWith((message) => updates(message as TicketItem)) as TicketItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TicketItem create() => TicketItem._();
  @$core.override
  TicketItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TicketItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TicketItem>(create);
  static TicketItem? _defaultInstance;

  @$pb.TagNumber(1)
  MenuItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(MenuItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  MenuItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lineKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set lineKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLineKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<AppliedModifier> get modifiers => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get specialInstructions => $_getSZ(4);
  @$pb.TagNumber(5)
  set specialInstructions($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpecialInstructions() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpecialInstructions() => $_clearField(5);
}

class Ticket extends $pb.GeneratedMessage {
  factory Ticket({
    $core.String? id,
    $core.Iterable<TicketItem>? items,
    $core.int? subtotal,
    $core.int? tax,
    $core.int? total,
    $core.String? status,
    $fixnum.Int64? createdAt,
    $core.Iterable<Payment>? payments,
    $core.int? amountPaid,
    $core.int? changeDue,
    $core.int? ccFee,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (items != null) result.items.addAll(items);
    if (subtotal != null) result.subtotal = subtotal;
    if (tax != null) result.tax = tax;
    if (total != null) result.total = total;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (payments != null) result.payments.addAll(payments);
    if (amountPaid != null) result.amountPaid = amountPaid;
    if (changeDue != null) result.changeDue = changeDue;
    if (ccFee != null) result.ccFee = ccFee;
    return result;
  }

  Ticket._();

  factory Ticket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ticket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ticket',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..pPM<TicketItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: TicketItem.create)
    ..aI(3, _omitFieldNames ? '' : 'subtotal')
    ..aI(4, _omitFieldNames ? '' : 'tax')
    ..aI(5, _omitFieldNames ? '' : 'total')
    ..aOS(6, _omitFieldNames ? '' : 'status')
    ..aInt64(7, _omitFieldNames ? '' : 'createdAt')
    ..pPM<Payment>(8, _omitFieldNames ? '' : 'payments',
        subBuilder: Payment.create)
    ..aI(9, _omitFieldNames ? '' : 'amountPaid')
    ..aI(10, _omitFieldNames ? '' : 'changeDue')
    ..aI(11, _omitFieldNames ? '' : 'ccFee')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ticket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ticket copyWith(void Function(Ticket) updates) =>
      super.copyWith((message) => updates(message as Ticket)) as Ticket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ticket create() => Ticket._();
  @$core.override
  Ticket createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ticket getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ticket>(create);
  static Ticket? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<TicketItem> get items => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get subtotal => $_getIZ(2);
  @$pb.TagNumber(3)
  set subtotal($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtotal() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtotal() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get tax => $_getIZ(3);
  @$pb.TagNumber(4)
  set tax($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTax() => $_has(3);
  @$pb.TagNumber(4)
  void clearTax() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get total => $_getIZ(4);
  @$pb.TagNumber(5)
  set total($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotal() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotal() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get status => $_getSZ(5);
  @$pb.TagNumber(6)
  set status($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAt => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<Payment> get payments => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get amountPaid => $_getIZ(8);
  @$pb.TagNumber(9)
  set amountPaid($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAmountPaid() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmountPaid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get changeDue => $_getIZ(9);
  @$pb.TagNumber(10)
  set changeDue($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasChangeDue() => $_has(9);
  @$pb.TagNumber(10)
  void clearChangeDue() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get ccFee => $_getIZ(10);
  @$pb.TagNumber(11)
  set ccFee($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCcFee() => $_has(10);
  @$pb.TagNumber(11)
  void clearCcFee() => $_clearField(11);
}

class Payment extends $pb.GeneratedMessage {
  factory Payment({
    $core.String? paymentType,
    $core.int? amountCents,
  }) {
    final result = create();
    if (paymentType != null) result.paymentType = paymentType;
    if (amountCents != null) result.amountCents = amountCents;
    return result;
  }

  Payment._();

  factory Payment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Payment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Payment',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'paymentType')
    ..aI(2, _omitFieldNames ? '' : 'amountCents')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Payment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Payment copyWith(void Function(Payment) updates) =>
      super.copyWith((message) => updates(message as Payment)) as Payment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Payment create() => Payment._();
  @$core.override
  Payment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Payment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Payment>(create);
  static Payment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get paymentType => $_getSZ(0);
  @$pb.TagNumber(1)
  set paymentType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPaymentType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get amountCents => $_getIZ(1);
  @$pb.TagNumber(2)
  set amountCents($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmountCents() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmountCents() => $_clearField(2);
}

class AddItemRequest extends $pb.GeneratedMessage {
  factory AddItemRequest({
    $core.String? ticketId,
    $core.String? menuItemId,
    $core.int? quantity,
    $core.Iterable<AppliedModifier>? modifiers,
    $core.String? specialInstructions,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (menuItemId != null) result.menuItemId = menuItemId;
    if (quantity != null) result.quantity = quantity;
    if (modifiers != null) result.modifiers.addAll(modifiers);
    if (specialInstructions != null)
      result.specialInstructions = specialInstructions;
    return result;
  }

  AddItemRequest._();

  factory AddItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddItemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'menuItemId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..pPM<AppliedModifier>(4, _omitFieldNames ? '' : 'modifiers',
        subBuilder: AppliedModifier.create)
    ..aOS(5, _omitFieldNames ? '' : 'specialInstructions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemRequest copyWith(void Function(AddItemRequest) updates) =>
      super.copyWith((message) => updates(message as AddItemRequest))
          as AddItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddItemRequest create() => AddItemRequest._();
  @$core.override
  AddItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddItemRequest>(create);
  static AddItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get menuItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set menuItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMenuItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMenuItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<AppliedModifier> get modifiers => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get specialInstructions => $_getSZ(4);
  @$pb.TagNumber(5)
  set specialInstructions($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpecialInstructions() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpecialInstructions() => $_clearField(5);
}

class AddItemResponse extends $pb.GeneratedMessage {
  factory AddItemResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  AddItemResponse._();

  factory AddItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddItemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemResponse copyWith(void Function(AddItemResponse) updates) =>
      super.copyWith((message) => updates(message as AddItemResponse))
          as AddItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddItemResponse create() => AddItemResponse._();
  @$core.override
  AddItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddItemResponse>(create);
  static AddItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class RemoveItemRequest extends $pb.GeneratedMessage {
  factory RemoveItemRequest({
    $core.String? ticketId,
    $core.String? menuItemId,
    $core.String? lineKey,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (menuItemId != null) result.menuItemId = menuItemId;
    if (lineKey != null) result.lineKey = lineKey;
    return result;
  }

  RemoveItemRequest._();

  factory RemoveItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveItemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'menuItemId')
    ..aOS(3, _omitFieldNames ? '' : 'lineKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveItemRequest copyWith(void Function(RemoveItemRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveItemRequest))
          as RemoveItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveItemRequest create() => RemoveItemRequest._();
  @$core.override
  RemoveItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveItemRequest>(create);
  static RemoveItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get menuItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set menuItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMenuItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMenuItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lineKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set lineKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLineKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineKey() => $_clearField(3);
}

class RemoveItemResponse extends $pb.GeneratedMessage {
  factory RemoveItemResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  RemoveItemResponse._();

  factory RemoveItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveItemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveItemResponse copyWith(void Function(RemoveItemResponse) updates) =>
      super.copyWith((message) => updates(message as RemoveItemResponse))
          as RemoveItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveItemResponse create() => RemoveItemResponse._();
  @$core.override
  RemoveItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveItemResponse>(create);
  static RemoveItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class UpdateItemRequest extends $pb.GeneratedMessage {
  factory UpdateItemRequest({
    $core.String? ticketId,
    $core.String? lineKey,
    $core.Iterable<AppliedModifier>? modifiers,
    $core.String? specialInstructions,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (lineKey != null) result.lineKey = lineKey;
    if (modifiers != null) result.modifiers.addAll(modifiers);
    if (specialInstructions != null)
      result.specialInstructions = specialInstructions;
    return result;
  }

  UpdateItemRequest._();

  factory UpdateItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateItemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'lineKey')
    ..pPM<AppliedModifier>(3, _omitFieldNames ? '' : 'modifiers',
        subBuilder: AppliedModifier.create)
    ..aOS(4, _omitFieldNames ? '' : 'specialInstructions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateItemRequest copyWith(void Function(UpdateItemRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateItemRequest))
          as UpdateItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateItemRequest create() => UpdateItemRequest._();
  @$core.override
  UpdateItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateItemRequest>(create);
  static UpdateItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lineKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set lineKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLineKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearLineKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<AppliedModifier> get modifiers => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get specialInstructions => $_getSZ(3);
  @$pb.TagNumber(4)
  set specialInstructions($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpecialInstructions() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpecialInstructions() => $_clearField(4);
}

class UpdateItemResponse extends $pb.GeneratedMessage {
  factory UpdateItemResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  UpdateItemResponse._();

  factory UpdateItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateItemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateItemResponse copyWith(void Function(UpdateItemResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateItemResponse))
          as UpdateItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateItemResponse create() => UpdateItemResponse._();
  @$core.override
  UpdateItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateItemResponse>(create);
  static UpdateItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class DecreaseItemRequest extends $pb.GeneratedMessage {
  factory DecreaseItemRequest({
    $core.String? ticketId,
    $core.String? menuItemId,
    $core.String? lineKey,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (menuItemId != null) result.menuItemId = menuItemId;
    if (lineKey != null) result.lineKey = lineKey;
    return result;
  }

  DecreaseItemRequest._();

  factory DecreaseItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecreaseItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecreaseItemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'menuItemId')
    ..aOS(3, _omitFieldNames ? '' : 'lineKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecreaseItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecreaseItemRequest copyWith(void Function(DecreaseItemRequest) updates) =>
      super.copyWith((message) => updates(message as DecreaseItemRequest))
          as DecreaseItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecreaseItemRequest create() => DecreaseItemRequest._();
  @$core.override
  DecreaseItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecreaseItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecreaseItemRequest>(create);
  static DecreaseItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get menuItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set menuItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMenuItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMenuItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lineKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set lineKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLineKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineKey() => $_clearField(3);
}

class DecreaseItemResponse extends $pb.GeneratedMessage {
  factory DecreaseItemResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  DecreaseItemResponse._();

  factory DecreaseItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecreaseItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecreaseItemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecreaseItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecreaseItemResponse copyWith(void Function(DecreaseItemResponse) updates) =>
      super.copyWith((message) => updates(message as DecreaseItemResponse))
          as DecreaseItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecreaseItemResponse create() => DecreaseItemResponse._();
  @$core.override
  DecreaseItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecreaseItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecreaseItemResponse>(create);
  static DecreaseItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class GetTicketRequest extends $pb.GeneratedMessage {
  factory GetTicketRequest({
    $core.String? ticketId,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    return result;
  }

  GetTicketRequest._();

  factory GetTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTicketRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketRequest copyWith(void Function(GetTicketRequest) updates) =>
      super.copyWith((message) => updates(message as GetTicketRequest))
          as GetTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTicketRequest create() => GetTicketRequest._();
  @$core.override
  GetTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTicketRequest>(create);
  static GetTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);
}

class GetTicketResponse extends $pb.GeneratedMessage {
  factory GetTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  GetTicketResponse._();

  factory GetTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTicketResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketResponse copyWith(void Function(GetTicketResponse) updates) =>
      super.copyWith((message) => updates(message as GetTicketResponse))
          as GetTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTicketResponse create() => GetTicketResponse._();
  @$core.override
  GetTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTicketResponse>(create);
  static GetTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class NewTicketRequest extends $pb.GeneratedMessage {
  factory NewTicketRequest() => create();

  NewTicketRequest._();

  factory NewTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NewTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewTicketRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTicketRequest copyWith(void Function(NewTicketRequest) updates) =>
      super.copyWith((message) => updates(message as NewTicketRequest))
          as NewTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewTicketRequest create() => NewTicketRequest._();
  @$core.override
  NewTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NewTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewTicketRequest>(create);
  static NewTicketRequest? _defaultInstance;
}

class NewTicketResponse extends $pb.GeneratedMessage {
  factory NewTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  NewTicketResponse._();

  factory NewTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NewTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewTicketResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTicketResponse copyWith(void Function(NewTicketResponse) updates) =>
      super.copyWith((message) => updates(message as NewTicketResponse))
          as NewTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewTicketResponse create() => NewTicketResponse._();
  @$core.override
  NewTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NewTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewTicketResponse>(create);
  static NewTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class CheckoutRequest extends $pb.GeneratedMessage {
  factory CheckoutRequest({
    $core.String? ticketId,
    $core.Iterable<Payment>? payments,
    $core.int? ccFeeCents,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (payments != null) result.payments.addAll(payments);
    if (ccFeeCents != null) result.ccFeeCents = ccFeeCents;
    return result;
  }

  CheckoutRequest._();

  factory CheckoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckoutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..pPM<Payment>(2, _omitFieldNames ? '' : 'payments',
        subBuilder: Payment.create)
    ..aI(3, _omitFieldNames ? '' : 'ccFeeCents')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckoutRequest copyWith(void Function(CheckoutRequest) updates) =>
      super.copyWith((message) => updates(message as CheckoutRequest))
          as CheckoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckoutRequest create() => CheckoutRequest._();
  @$core.override
  CheckoutRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckoutRequest>(create);
  static CheckoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Payment> get payments => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get ccFeeCents => $_getIZ(2);
  @$pb.TagNumber(3)
  set ccFeeCents($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCcFeeCents() => $_has(2);
  @$pb.TagNumber(3)
  void clearCcFeeCents() => $_clearField(3);
}

class CheckoutResponse extends $pb.GeneratedMessage {
  factory CheckoutResponse({
    $core.bool? success,
    Ticket? ticket,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (ticket != null) result.ticket = ticket;
    if (error != null) result.error = error;
    return result;
  }

  CheckoutResponse._();

  factory CheckoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<Ticket>(2, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckoutResponse copyWith(void Function(CheckoutResponse) updates) =>
      super.copyWith((message) => updates(message as CheckoutResponse))
          as CheckoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckoutResponse create() => CheckoutResponse._();
  @$core.override
  CheckoutResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckoutResponse>(create);
  static CheckoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  Ticket get ticket => $_getN(1);
  @$pb.TagNumber(2)
  set ticket(Ticket value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTicket() => $_has(1);
  @$pb.TagNumber(2)
  void clearTicket() => $_clearField(2);
  @$pb.TagNumber(2)
  Ticket ensureTicket() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

class ListTicketsRequest extends $pb.GeneratedMessage {
  factory ListTicketsRequest({
    $core.String? date,
    $core.String? status,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (status != null) result.status = status;
    return result;
  }

  ListTicketsRequest._();

  factory ListTicketsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTicketsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTicketsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsRequest copyWith(void Function(ListTicketsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTicketsRequest))
          as ListTicketsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTicketsRequest create() => ListTicketsRequest._();
  @$core.override
  ListTicketsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTicketsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTicketsRequest>(create);
  static ListTicketsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class ListTicketsResponse extends $pb.GeneratedMessage {
  factory ListTicketsResponse({
    $core.Iterable<Ticket>? tickets,
  }) {
    final result = create();
    if (tickets != null) result.tickets.addAll(tickets);
    return result;
  }

  ListTicketsResponse._();

  factory ListTicketsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTicketsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTicketsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..pPM<Ticket>(1, _omitFieldNames ? '' : 'tickets',
        subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsResponse copyWith(void Function(ListTicketsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTicketsResponse))
          as ListTicketsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTicketsResponse create() => ListTicketsResponse._();
  @$core.override
  ListTicketsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTicketsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTicketsResponse>(create);
  static ListTicketsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Ticket> get tickets => $_getList(0);
}

class TicketActionRequest extends $pb.GeneratedMessage {
  factory TicketActionRequest({
    $core.String? ticketId,
    $core.String? action,
    $core.String? reason,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (action != null) result.action = action;
    if (reason != null) result.reason = reason;
    return result;
  }

  TicketActionRequest._();

  factory TicketActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TicketActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TicketActionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'action')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TicketActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TicketActionRequest copyWith(void Function(TicketActionRequest) updates) =>
      super.copyWith((message) => updates(message as TicketActionRequest))
          as TicketActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TicketActionRequest create() => TicketActionRequest._();
  @$core.override
  TicketActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TicketActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TicketActionRequest>(create);
  static TicketActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get action => $_getSZ(1);
  @$pb.TagNumber(2)
  set action($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class TicketActionResponse extends $pb.GeneratedMessage {
  factory TicketActionResponse({
    $core.bool? success,
    Ticket? ticket,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (ticket != null) result.ticket = ticket;
    if (error != null) result.error = error;
    return result;
  }

  TicketActionResponse._();

  factory TicketActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TicketActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TicketActionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<Ticket>(2, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TicketActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TicketActionResponse copyWith(void Function(TicketActionResponse) updates) =>
      super.copyWith((message) => updates(message as TicketActionResponse))
          as TicketActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TicketActionResponse create() => TicketActionResponse._();
  @$core.override
  TicketActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TicketActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TicketActionResponse>(create);
  static TicketActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  Ticket get ticket => $_getN(1);
  @$pb.TagNumber(2)
  set ticket(Ticket value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTicket() => $_has(1);
  @$pb.TagNumber(2)
  void clearTicket() => $_clearField(2);
  @$pb.TagNumber(2)
  Ticket ensureTicket() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

class PrintReceiptRequest extends $pb.GeneratedMessage {
  factory PrintReceiptRequest({
    $core.String? ticketId,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    return result;
  }

  PrintReceiptRequest._();

  factory PrintReceiptRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintReceiptRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintReceiptRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReceiptRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReceiptRequest copyWith(void Function(PrintReceiptRequest) updates) =>
      super.copyWith((message) => updates(message as PrintReceiptRequest))
          as PrintReceiptRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintReceiptRequest create() => PrintReceiptRequest._();
  @$core.override
  PrintReceiptRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrintReceiptRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintReceiptRequest>(create);
  static PrintReceiptRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);
}

class PrintReceiptResponse extends $pb.GeneratedMessage {
  factory PrintReceiptResponse({
    $core.bool? success,
    $core.String? error,
    $core.int? jobId,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  PrintReceiptResponse._();

  factory PrintReceiptResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintReceiptResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintReceiptResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aI(3, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReceiptResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReceiptResponse copyWith(void Function(PrintReceiptResponse) updates) =>
      super.copyWith((message) => updates(message as PrintReceiptResponse))
          as PrintReceiptResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintReceiptResponse create() => PrintReceiptResponse._();
  @$core.override
  PrintReceiptResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrintReceiptResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintReceiptResponse>(create);
  static PrintReceiptResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get jobId => $_getIZ(2);
  @$pb.TagNumber(3)
  set jobId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearJobId() => $_clearField(3);
}

class PrintStatusEvent extends $pb.GeneratedMessage {
  factory PrintStatusEvent({
    $core.int? jobId,
    $core.String? status,
    $core.String? message,
  }) {
    final result = create();
    if (jobId != null) result.jobId = jobId;
    if (status != null) result.status = status;
    if (message != null) result.message = message;
    return result;
  }

  PrintStatusEvent._();

  factory PrintStatusEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintStatusEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintStatusEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'jobId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintStatusEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintStatusEvent copyWith(void Function(PrintStatusEvent) updates) =>
      super.copyWith((message) => updates(message as PrintStatusEvent))
          as PrintStatusEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintStatusEvent create() => PrintStatusEvent._();
  @$core.override
  PrintStatusEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrintStatusEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintStatusEvent>(create);
  static PrintStatusEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get jobId => $_getIZ(0);
  @$pb.TagNumber(1)
  set jobId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class GetMenuRequest extends $pb.GeneratedMessage {
  factory GetMenuRequest() => create();

  GetMenuRequest._();

  factory GetMenuRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMenuRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMenuRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMenuRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMenuRequest copyWith(void Function(GetMenuRequest) updates) =>
      super.copyWith((message) => updates(message as GetMenuRequest))
          as GetMenuRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMenuRequest create() => GetMenuRequest._();
  @$core.override
  GetMenuRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMenuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMenuRequest>(create);
  static GetMenuRequest? _defaultInstance;
}

class GetMenuResponse extends $pb.GeneratedMessage {
  factory GetMenuResponse({
    $core.Iterable<MenuItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  GetMenuResponse._();

  factory GetMenuResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMenuResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMenuResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..pPM<MenuItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: MenuItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMenuResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMenuResponse copyWith(void Function(GetMenuResponse) updates) =>
      super.copyWith((message) => updates(message as GetMenuResponse))
          as GetMenuResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMenuResponse create() => GetMenuResponse._();
  @$core.override
  GetMenuResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMenuResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMenuResponse>(create);
  static GetMenuResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MenuItem> get items => $_getList(0);
}

class Settings extends $pb.GeneratedMessage {
  factory Settings({
    $core.String? restaurantName,
    $core.int? taxRateBps,
    $core.String? receiptPrinterName,
    $core.bool? receiptPrinterEnabled,
    $core.String? kitchenPrinterName,
    $core.bool? kitchenPrinterEnabled,
    $core.int? ccFeeCents,
    $core.int? ccFeeBps,
  }) {
    final result = create();
    if (restaurantName != null) result.restaurantName = restaurantName;
    if (taxRateBps != null) result.taxRateBps = taxRateBps;
    if (receiptPrinterName != null)
      result.receiptPrinterName = receiptPrinterName;
    if (receiptPrinterEnabled != null)
      result.receiptPrinterEnabled = receiptPrinterEnabled;
    if (kitchenPrinterName != null)
      result.kitchenPrinterName = kitchenPrinterName;
    if (kitchenPrinterEnabled != null)
      result.kitchenPrinterEnabled = kitchenPrinterEnabled;
    if (ccFeeCents != null) result.ccFeeCents = ccFeeCents;
    if (ccFeeBps != null) result.ccFeeBps = ccFeeBps;
    return result;
  }

  Settings._();

  factory Settings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Settings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Settings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'restaurantName')
    ..aI(2, _omitFieldNames ? '' : 'taxRateBps')
    ..aOS(3, _omitFieldNames ? '' : 'receiptPrinterName')
    ..aOB(4, _omitFieldNames ? '' : 'receiptPrinterEnabled')
    ..aOS(5, _omitFieldNames ? '' : 'kitchenPrinterName')
    ..aOB(6, _omitFieldNames ? '' : 'kitchenPrinterEnabled')
    ..aI(7, _omitFieldNames ? '' : 'ccFeeCents')
    ..aI(8, _omitFieldNames ? '' : 'ccFeeBps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settings copyWith(void Function(Settings) updates) =>
      super.copyWith((message) => updates(message as Settings)) as Settings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Settings create() => Settings._();
  @$core.override
  Settings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Settings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Settings>(create);
  static Settings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get restaurantName => $_getSZ(0);
  @$pb.TagNumber(1)
  set restaurantName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRestaurantName() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestaurantName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get taxRateBps => $_getIZ(1);
  @$pb.TagNumber(2)
  set taxRateBps($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaxRateBps() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaxRateBps() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get receiptPrinterName => $_getSZ(2);
  @$pb.TagNumber(3)
  set receiptPrinterName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReceiptPrinterName() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiptPrinterName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get receiptPrinterEnabled => $_getBF(3);
  @$pb.TagNumber(4)
  set receiptPrinterEnabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReceiptPrinterEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceiptPrinterEnabled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get kitchenPrinterName => $_getSZ(4);
  @$pb.TagNumber(5)
  set kitchenPrinterName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasKitchenPrinterName() => $_has(4);
  @$pb.TagNumber(5)
  void clearKitchenPrinterName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get kitchenPrinterEnabled => $_getBF(5);
  @$pb.TagNumber(6)
  set kitchenPrinterEnabled($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasKitchenPrinterEnabled() => $_has(5);
  @$pb.TagNumber(6)
  void clearKitchenPrinterEnabled() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get ccFeeCents => $_getIZ(6);
  @$pb.TagNumber(7)
  set ccFeeCents($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCcFeeCents() => $_has(6);
  @$pb.TagNumber(7)
  void clearCcFeeCents() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get ccFeeBps => $_getIZ(7);
  @$pb.TagNumber(8)
  set ccFeeBps($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCcFeeBps() => $_has(7);
  @$pb.TagNumber(8)
  void clearCcFeeBps() => $_clearField(8);
}

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => create();

  GetSettingsRequest._();

  factory GetSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsRequest))
          as GetSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest create() => GetSettingsRequest._();
  @$core.override
  GetSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(create);
  static GetSettingsRequest? _defaultInstance;
}

class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    Settings? settings,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    return result;
  }

  GetSettingsResponse._();

  factory GetSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSettingsResponse))
          as GetSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse create() => GetSettingsResponse._();
  @$core.override
  GetSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(create);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    Settings? settings,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest copyWith(
          void Function(UpdateSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsRequest))
          as UpdateSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  @$core.override
  UpdateSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(create);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);
}

class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    Settings? settings,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateSettingsResponse._();

  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<Settings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: Settings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse copyWith(
          void Function(UpdateSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsResponse))
          as UpdateSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  @$core.override
  UpdateSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(create);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(Settings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  Settings ensureSettings() => $_ensure(0);
}

class PrinterInfo extends $pb.GeneratedMessage {
  factory PrinterInfo({
    $core.String? name,
    $core.String? description,
    $core.String? uri,
    $core.bool? isDefault,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (uri != null) result.uri = uri;
    if (isDefault != null) result.isDefault = isDefault;
    return result;
  }

  PrinterInfo._();

  factory PrinterInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrinterInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrinterInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOB(4, _omitFieldNames ? '' : 'isDefault')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrinterInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrinterInfo copyWith(void Function(PrinterInfo) updates) =>
      super.copyWith((message) => updates(message as PrinterInfo))
          as PrinterInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrinterInfo create() => PrinterInfo._();
  @$core.override
  PrinterInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrinterInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrinterInfo>(create);
  static PrinterInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isDefault => $_getBF(3);
  @$pb.TagNumber(4)
  set isDefault($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsDefault() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsDefault() => $_clearField(4);
}

class ListPrintersRequest extends $pb.GeneratedMessage {
  factory ListPrintersRequest() => create();

  ListPrintersRequest._();

  factory ListPrintersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPrintersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPrintersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrintersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrintersRequest copyWith(void Function(ListPrintersRequest) updates) =>
      super.copyWith((message) => updates(message as ListPrintersRequest))
          as ListPrintersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPrintersRequest create() => ListPrintersRequest._();
  @$core.override
  ListPrintersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPrintersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPrintersRequest>(create);
  static ListPrintersRequest? _defaultInstance;
}

class ListPrintersResponse extends $pb.GeneratedMessage {
  factory ListPrintersResponse({
    $core.Iterable<PrinterInfo>? printers,
  }) {
    final result = create();
    if (printers != null) result.printers.addAll(printers);
    return result;
  }

  ListPrintersResponse._();

  factory ListPrintersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPrintersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPrintersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..pPM<PrinterInfo>(1, _omitFieldNames ? '' : 'printers',
        subBuilder: PrinterInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrintersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrintersResponse copyWith(void Function(ListPrintersResponse) updates) =>
      super.copyWith((message) => updates(message as ListPrintersResponse))
          as ListPrintersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPrintersResponse create() => ListPrintersResponse._();
  @$core.override
  ListPrintersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPrintersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPrintersResponse>(create);
  static ListPrintersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PrinterInfo> get printers => $_getList(0);
}

class PrintKitchenRequest extends $pb.GeneratedMessage {
  factory PrintKitchenRequest({
    $core.String? ticketId,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    return result;
  }

  PrintKitchenRequest._();

  factory PrintKitchenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintKitchenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintKitchenRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintKitchenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintKitchenRequest copyWith(void Function(PrintKitchenRequest) updates) =>
      super.copyWith((message) => updates(message as PrintKitchenRequest))
          as PrintKitchenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintKitchenRequest create() => PrintKitchenRequest._();
  @$core.override
  PrintKitchenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrintKitchenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintKitchenRequest>(create);
  static PrintKitchenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);
}

class PrintKitchenResponse extends $pb.GeneratedMessage {
  factory PrintKitchenResponse({
    $core.bool? success,
    $core.String? error,
    $core.int? jobId,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  PrintKitchenResponse._();

  factory PrintKitchenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintKitchenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintKitchenResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aI(3, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintKitchenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintKitchenResponse copyWith(void Function(PrintKitchenResponse) updates) =>
      super.copyWith((message) => updates(message as PrintKitchenResponse))
          as PrintKitchenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintKitchenResponse create() => PrintKitchenResponse._();
  @$core.override
  PrintKitchenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrintKitchenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintKitchenResponse>(create);
  static PrintKitchenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get jobId => $_getIZ(2);
  @$pb.TagNumber(3)
  set jobId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearJobId() => $_clearField(3);
}

class AddMenuItemRequest extends $pb.GeneratedMessage {
  factory AddMenuItemRequest({
    MenuItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  AddMenuItemRequest._();

  factory AddMenuItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMenuItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMenuItemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<MenuItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: MenuItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMenuItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMenuItemRequest copyWith(void Function(AddMenuItemRequest) updates) =>
      super.copyWith((message) => updates(message as AddMenuItemRequest))
          as AddMenuItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMenuItemRequest create() => AddMenuItemRequest._();
  @$core.override
  AddMenuItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMenuItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMenuItemRequest>(create);
  static AddMenuItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  MenuItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(MenuItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  MenuItem ensureItem() => $_ensure(0);
}

class AddMenuItemResponse extends $pb.GeneratedMessage {
  factory AddMenuItemResponse({
    MenuItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  AddMenuItemResponse._();

  factory AddMenuItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMenuItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMenuItemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<MenuItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: MenuItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMenuItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMenuItemResponse copyWith(void Function(AddMenuItemResponse) updates) =>
      super.copyWith((message) => updates(message as AddMenuItemResponse))
          as AddMenuItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMenuItemResponse create() => AddMenuItemResponse._();
  @$core.override
  AddMenuItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMenuItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMenuItemResponse>(create);
  static AddMenuItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MenuItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(MenuItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  MenuItem ensureItem() => $_ensure(0);
}

class UpdateMenuItemRequest extends $pb.GeneratedMessage {
  factory UpdateMenuItemRequest({
    MenuItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  UpdateMenuItemRequest._();

  factory UpdateMenuItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMenuItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMenuItemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<MenuItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: MenuItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMenuItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMenuItemRequest copyWith(
          void Function(UpdateMenuItemRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateMenuItemRequest))
          as UpdateMenuItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMenuItemRequest create() => UpdateMenuItemRequest._();
  @$core.override
  UpdateMenuItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateMenuItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMenuItemRequest>(create);
  static UpdateMenuItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  MenuItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(MenuItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  MenuItem ensureItem() => $_ensure(0);
}

class UpdateMenuItemResponse extends $pb.GeneratedMessage {
  factory UpdateMenuItemResponse({
    MenuItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  UpdateMenuItemResponse._();

  factory UpdateMenuItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMenuItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMenuItemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<MenuItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: MenuItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMenuItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMenuItemResponse copyWith(
          void Function(UpdateMenuItemResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateMenuItemResponse))
          as UpdateMenuItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMenuItemResponse create() => UpdateMenuItemResponse._();
  @$core.override
  UpdateMenuItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateMenuItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMenuItemResponse>(create);
  static UpdateMenuItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MenuItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(MenuItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  MenuItem ensureItem() => $_ensure(0);
}

class DeleteMenuItemRequest extends $pb.GeneratedMessage {
  factory DeleteMenuItemRequest({
    $core.String? itemId,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    return result;
  }

  DeleteMenuItemRequest._();

  factory DeleteMenuItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteMenuItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteMenuItemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMenuItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMenuItemRequest copyWith(
          void Function(DeleteMenuItemRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteMenuItemRequest))
          as DeleteMenuItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMenuItemRequest create() => DeleteMenuItemRequest._();
  @$core.override
  DeleteMenuItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteMenuItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteMenuItemRequest>(create);
  static DeleteMenuItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);
}

class DeleteMenuItemResponse extends $pb.GeneratedMessage {
  factory DeleteMenuItemResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteMenuItemResponse._();

  factory DeleteMenuItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteMenuItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteMenuItemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMenuItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMenuItemResponse copyWith(
          void Function(DeleteMenuItemResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteMenuItemResponse))
          as DeleteMenuItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMenuItemResponse create() => DeleteMenuItemResponse._();
  @$core.override
  DeleteMenuItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteMenuItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteMenuItemResponse>(create);
  static DeleteMenuItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ItemSalesEntry extends $pb.GeneratedMessage {
  factory ItemSalesEntry({
    $core.String? itemName,
    $core.int? quantitySold,
    $core.int? revenueCents,
  }) {
    final result = create();
    if (itemName != null) result.itemName = itemName;
    if (quantitySold != null) result.quantitySold = quantitySold;
    if (revenueCents != null) result.revenueCents = revenueCents;
    return result;
  }

  ItemSalesEntry._();

  factory ItemSalesEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ItemSalesEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemSalesEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemName')
    ..aI(2, _omitFieldNames ? '' : 'quantitySold')
    ..aI(3, _omitFieldNames ? '' : 'revenueCents')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemSalesEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemSalesEntry copyWith(void Function(ItemSalesEntry) updates) =>
      super.copyWith((message) => updates(message as ItemSalesEntry))
          as ItemSalesEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ItemSalesEntry create() => ItemSalesEntry._();
  @$core.override
  ItemSalesEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ItemSalesEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ItemSalesEntry>(create);
  static ItemSalesEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemName => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemName() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantitySold => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantitySold($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantitySold() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantitySold() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get revenueCents => $_getIZ(2);
  @$pb.TagNumber(3)
  set revenueCents($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevenueCents() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevenueCents() => $_clearField(3);
}

class DailyReport extends $pb.GeneratedMessage {
  factory DailyReport({
    $core.String? date,
    $core.int? totalTickets,
    $core.int? totalRevenueCents,
    $core.int? totalTaxCents,
    $core.int? cashCount,
    $core.int? cardCount,
    $core.int? voidedCount,
    $core.Iterable<ItemSalesEntry>? itemSales,
    $core.int? compedCount,
    $core.int? refundedCount,
    $core.int? cashTotalCents,
    $core.int? cardTotalCents,
    $core.int? compedTotalCents,
    $core.int? refundedTotalCents,
    $core.int? netRevenueCents,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (totalTickets != null) result.totalTickets = totalTickets;
    if (totalRevenueCents != null) result.totalRevenueCents = totalRevenueCents;
    if (totalTaxCents != null) result.totalTaxCents = totalTaxCents;
    if (cashCount != null) result.cashCount = cashCount;
    if (cardCount != null) result.cardCount = cardCount;
    if (voidedCount != null) result.voidedCount = voidedCount;
    if (itemSales != null) result.itemSales.addAll(itemSales);
    if (compedCount != null) result.compedCount = compedCount;
    if (refundedCount != null) result.refundedCount = refundedCount;
    if (cashTotalCents != null) result.cashTotalCents = cashTotalCents;
    if (cardTotalCents != null) result.cardTotalCents = cardTotalCents;
    if (compedTotalCents != null) result.compedTotalCents = compedTotalCents;
    if (refundedTotalCents != null)
      result.refundedTotalCents = refundedTotalCents;
    if (netRevenueCents != null) result.netRevenueCents = netRevenueCents;
    return result;
  }

  DailyReport._();

  factory DailyReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DailyReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DailyReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..aI(2, _omitFieldNames ? '' : 'totalTickets')
    ..aI(3, _omitFieldNames ? '' : 'totalRevenueCents')
    ..aI(4, _omitFieldNames ? '' : 'totalTaxCents')
    ..aI(5, _omitFieldNames ? '' : 'cashCount')
    ..aI(6, _omitFieldNames ? '' : 'cardCount')
    ..aI(7, _omitFieldNames ? '' : 'voidedCount')
    ..pPM<ItemSalesEntry>(8, _omitFieldNames ? '' : 'itemSales',
        subBuilder: ItemSalesEntry.create)
    ..aI(9, _omitFieldNames ? '' : 'compedCount')
    ..aI(10, _omitFieldNames ? '' : 'refundedCount')
    ..aI(11, _omitFieldNames ? '' : 'cashTotalCents')
    ..aI(12, _omitFieldNames ? '' : 'cardTotalCents')
    ..aI(13, _omitFieldNames ? '' : 'compedTotalCents')
    ..aI(14, _omitFieldNames ? '' : 'refundedTotalCents')
    ..aI(15, _omitFieldNames ? '' : 'netRevenueCents')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReport copyWith(void Function(DailyReport) updates) =>
      super.copyWith((message) => updates(message as DailyReport))
          as DailyReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DailyReport create() => DailyReport._();
  @$core.override
  DailyReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DailyReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DailyReport>(create);
  static DailyReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalTickets => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalTickets($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalTickets() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalTickets() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalRevenueCents => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalRevenueCents($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalRevenueCents() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalRevenueCents() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalTaxCents => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalTaxCents($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalTaxCents() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalTaxCents() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get cashCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set cashCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCashCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearCashCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get cardCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set cardCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCardCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCardCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get voidedCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set voidedCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVoidedCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearVoidedCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<ItemSalesEntry> get itemSales => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get compedCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set compedCount($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCompedCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompedCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get refundedCount => $_getIZ(9);
  @$pb.TagNumber(10)
  set refundedCount($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRefundedCount() => $_has(9);
  @$pb.TagNumber(10)
  void clearRefundedCount() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get cashTotalCents => $_getIZ(10);
  @$pb.TagNumber(11)
  set cashTotalCents($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCashTotalCents() => $_has(10);
  @$pb.TagNumber(11)
  void clearCashTotalCents() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get cardTotalCents => $_getIZ(11);
  @$pb.TagNumber(12)
  set cardTotalCents($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCardTotalCents() => $_has(11);
  @$pb.TagNumber(12)
  void clearCardTotalCents() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get compedTotalCents => $_getIZ(12);
  @$pb.TagNumber(13)
  set compedTotalCents($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCompedTotalCents() => $_has(12);
  @$pb.TagNumber(13)
  void clearCompedTotalCents() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get refundedTotalCents => $_getIZ(13);
  @$pb.TagNumber(14)
  set refundedTotalCents($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRefundedTotalCents() => $_has(13);
  @$pb.TagNumber(14)
  void clearRefundedTotalCents() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get netRevenueCents => $_getIZ(14);
  @$pb.TagNumber(15)
  set netRevenueCents($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNetRevenueCents() => $_has(14);
  @$pb.TagNumber(15)
  void clearNetRevenueCents() => $_clearField(15);
}

class DailyReportRequest extends $pb.GeneratedMessage {
  factory DailyReportRequest({
    $core.String? date,
  }) {
    final result = create();
    if (date != null) result.date = date;
    return result;
  }

  DailyReportRequest._();

  factory DailyReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DailyReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DailyReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReportRequest copyWith(void Function(DailyReportRequest) updates) =>
      super.copyWith((message) => updates(message as DailyReportRequest))
          as DailyReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DailyReportRequest create() => DailyReportRequest._();
  @$core.override
  DailyReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DailyReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DailyReportRequest>(create);
  static DailyReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
}

class DailyReportResponse extends $pb.GeneratedMessage {
  factory DailyReportResponse({
    DailyReport? report,
  }) {
    final result = create();
    if (report != null) result.report = report;
    return result;
  }

  DailyReportResponse._();

  factory DailyReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DailyReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DailyReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<DailyReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: DailyReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DailyReportResponse copyWith(void Function(DailyReportResponse) updates) =>
      super.copyWith((message) => updates(message as DailyReportResponse))
          as DailyReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DailyReportResponse create() => DailyReportResponse._();
  @$core.override
  DailyReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DailyReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DailyReportResponse>(create);
  static DailyReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DailyReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(DailyReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  DailyReport ensureReport() => $_ensure(0);
}

class ReportHistoryRequest extends $pb.GeneratedMessage {
  factory ReportHistoryRequest({
    $core.int? daysBack,
  }) {
    final result = create();
    if (daysBack != null) result.daysBack = daysBack;
    return result;
  }

  ReportHistoryRequest._();

  factory ReportHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'daysBack')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportHistoryRequest copyWith(void Function(ReportHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as ReportHistoryRequest))
          as ReportHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportHistoryRequest create() => ReportHistoryRequest._();
  @$core.override
  ReportHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportHistoryRequest>(create);
  static ReportHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get daysBack => $_getIZ(0);
  @$pb.TagNumber(1)
  set daysBack($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDaysBack() => $_has(0);
  @$pb.TagNumber(1)
  void clearDaysBack() => $_clearField(1);
}

class ReportHistoryResponse extends $pb.GeneratedMessage {
  factory ReportHistoryResponse({
    $core.Iterable<DailyReport>? reports,
  }) {
    final result = create();
    if (reports != null) result.reports.addAll(reports);
    return result;
  }

  ReportHistoryResponse._();

  factory ReportHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportHistoryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..pPM<DailyReport>(1, _omitFieldNames ? '' : 'reports',
        subBuilder: DailyReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportHistoryResponse copyWith(
          void Function(ReportHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as ReportHistoryResponse))
          as ReportHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportHistoryResponse create() => ReportHistoryResponse._();
  @$core.override
  ReportHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportHistoryResponse>(create);
  static ReportHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DailyReport> get reports => $_getList(0);
}

class DateRangeReportRequest extends $pb.GeneratedMessage {
  factory DateRangeReportRequest({
    $core.String? startDate,
    $core.String? endDate,
  }) {
    final result = create();
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  DateRangeReportRequest._();

  factory DateRangeReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DateRangeReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DateRangeReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'startDate')
    ..aOS(2, _omitFieldNames ? '' : 'endDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRangeReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRangeReportRequest copyWith(
          void Function(DateRangeReportRequest) updates) =>
      super.copyWith((message) => updates(message as DateRangeReportRequest))
          as DateRangeReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DateRangeReportRequest create() => DateRangeReportRequest._();
  @$core.override
  DateRangeReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DateRangeReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DateRangeReportRequest>(create);
  static DateRangeReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get startDate => $_getSZ(0);
  @$pb.TagNumber(1)
  set startDate($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get endDate => $_getSZ(1);
  @$pb.TagNumber(2)
  set endDate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndDate() => $_clearField(2);
}

class DateRangeReportResponse extends $pb.GeneratedMessage {
  factory DateRangeReportResponse({
    DailyReport? summary,
    $core.Iterable<DailyReport>? dailyReports,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    if (dailyReports != null) result.dailyReports.addAll(dailyReports);
    return result;
  }

  DateRangeReportResponse._();

  factory DateRangeReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DateRangeReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DateRangeReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOM<DailyReport>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: DailyReport.create)
    ..pPM<DailyReport>(2, _omitFieldNames ? '' : 'dailyReports',
        subBuilder: DailyReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRangeReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DateRangeReportResponse copyWith(
          void Function(DateRangeReportResponse) updates) =>
      super.copyWith((message) => updates(message as DateRangeReportResponse))
          as DateRangeReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DateRangeReportResponse create() => DateRangeReportResponse._();
  @$core.override
  DateRangeReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DateRangeReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DateRangeReportResponse>(create);
  static DateRangeReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DailyReport get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(DailyReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  DailyReport ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<DailyReport> get dailyReports => $_getList(1);
}

class PrintReportRequest extends $pb.GeneratedMessage {
  factory PrintReportRequest({
    $core.String? reportType,
    $core.String? date,
    $core.String? startDate,
    $core.String? endDate,
  }) {
    final result = create();
    if (reportType != null) result.reportType = reportType;
    if (date != null) result.date = date;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  PrintReportRequest._();

  factory PrintReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportType')
    ..aOS(2, _omitFieldNames ? '' : 'date')
    ..aOS(3, _omitFieldNames ? '' : 'startDate')
    ..aOS(4, _omitFieldNames ? '' : 'endDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReportRequest copyWith(void Function(PrintReportRequest) updates) =>
      super.copyWith((message) => updates(message as PrintReportRequest))
          as PrintReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintReportRequest create() => PrintReportRequest._();
  @$core.override
  PrintReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrintReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintReportRequest>(create);
  static PrintReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportType => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportType() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get date => $_getSZ(1);
  @$pb.TagNumber(2)
  set date($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get startDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set startDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartDate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get endDate => $_getSZ(3);
  @$pb.TagNumber(4)
  set endDate($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndDate() => $_clearField(4);
}

class PrintReportResponse extends $pb.GeneratedMessage {
  factory PrintReportResponse({
    $core.bool? success,
    $core.String? error,
    $core.int? jobId,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    if (jobId != null) result.jobId = jobId;
    return result;
  }

  PrintReportResponse._();

  factory PrintReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrintReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrintReportResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..aI(3, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrintReportResponse copyWith(void Function(PrintReportResponse) updates) =>
      super.copyWith((message) => updates(message as PrintReportResponse))
          as PrintReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrintReportResponse create() => PrintReportResponse._();
  @$core.override
  PrintReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrintReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrintReportResponse>(create);
  static PrintReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get jobId => $_getIZ(2);
  @$pb.TagNumber(3)
  set jobId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearJobId() => $_clearField(3);
}

class EndDayRequest extends $pb.GeneratedMessage {
  factory EndDayRequest() => create();

  EndDayRequest._();

  factory EndDayRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndDayRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndDayRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDayRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDayRequest copyWith(void Function(EndDayRequest) updates) =>
      super.copyWith((message) => updates(message as EndDayRequest))
          as EndDayRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndDayRequest create() => EndDayRequest._();
  @$core.override
  EndDayRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndDayRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndDayRequest>(create);
  static EndDayRequest? _defaultInstance;
}

class EndDayResponse extends $pb.GeneratedMessage {
  factory EndDayResponse({
    $core.bool? success,
    DailyReport? zReport,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (zReport != null) result.zReport = zReport;
    if (error != null) result.error = error;
    return result;
  }

  EndDayResponse._();

  factory EndDayResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndDayResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndDayResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<DailyReport>(2, _omitFieldNames ? '' : 'zReport',
        subBuilder: DailyReport.create)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDayResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDayResponse copyWith(void Function(EndDayResponse) updates) =>
      super.copyWith((message) => updates(message as EndDayResponse))
          as EndDayResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndDayResponse create() => EndDayResponse._();
  @$core.override
  EndDayResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndDayResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndDayResponse>(create);
  static EndDayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  DailyReport get zReport => $_getN(1);
  @$pb.TagNumber(2)
  set zReport(DailyReport value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasZReport() => $_has(1);
  @$pb.TagNumber(2)
  void clearZReport() => $_clearField(2);
  @$pb.TagNumber(2)
  DailyReport ensureZReport() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

class PhoneOrder extends $pb.GeneratedMessage {
  factory PhoneOrder({
    $core.String? id,
    Ticket? ticket,
    $core.String? customerName,
    $core.String? comment,
    $core.String? status,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (ticket != null) result.ticket = ticket;
    if (customerName != null) result.customerName = customerName;
    if (comment != null) result.comment = comment;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  PhoneOrder._();

  factory PhoneOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhoneOrder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Ticket>(2, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..aOS(3, _omitFieldNames ? '' : 'customerName')
    ..aOS(4, _omitFieldNames ? '' : 'comment')
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrder copyWith(void Function(PhoneOrder) updates) =>
      super.copyWith((message) => updates(message as PhoneOrder)) as PhoneOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneOrder create() => PhoneOrder._();
  @$core.override
  PhoneOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhoneOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneOrder>(create);
  static PhoneOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Ticket get ticket => $_getN(1);
  @$pb.TagNumber(2)
  set ticket(Ticket value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTicket() => $_has(1);
  @$pb.TagNumber(2)
  void clearTicket() => $_clearField(2);
  @$pb.TagNumber(2)
  Ticket ensureTicket() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get customerName => $_getSZ(2);
  @$pb.TagNumber(3)
  set customerName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCustomerName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomerName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get comment => $_getSZ(3);
  @$pb.TagNumber(4)
  set comment($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasComment() => $_has(3);
  @$pb.TagNumber(4)
  void clearComment() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAt => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
}

class CreatePhoneOrderRequest extends $pb.GeneratedMessage {
  factory CreatePhoneOrderRequest({
    $core.String? ticketId,
    $core.String? customerName,
    $core.String? comment,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (customerName != null) result.customerName = customerName;
    if (comment != null) result.comment = comment;
    return result;
  }

  CreatePhoneOrderRequest._();

  factory CreatePhoneOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePhoneOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePhoneOrderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'customerName')
    ..aOS(3, _omitFieldNames ? '' : 'comment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePhoneOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePhoneOrderRequest copyWith(
          void Function(CreatePhoneOrderRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePhoneOrderRequest))
          as CreatePhoneOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePhoneOrderRequest create() => CreatePhoneOrderRequest._();
  @$core.override
  CreatePhoneOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatePhoneOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePhoneOrderRequest>(create);
  static CreatePhoneOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get customerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCustomerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get comment => $_getSZ(2);
  @$pb.TagNumber(3)
  set comment($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComment() => $_has(2);
  @$pb.TagNumber(3)
  void clearComment() => $_clearField(3);
}

class CreatePhoneOrderResponse extends $pb.GeneratedMessage {
  factory CreatePhoneOrderResponse({
    $core.bool? success,
    PhoneOrder? phoneOrder,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (phoneOrder != null) result.phoneOrder = phoneOrder;
    if (error != null) result.error = error;
    return result;
  }

  CreatePhoneOrderResponse._();

  factory CreatePhoneOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePhoneOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePhoneOrderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<PhoneOrder>(2, _omitFieldNames ? '' : 'phoneOrder',
        subBuilder: PhoneOrder.create)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePhoneOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePhoneOrderResponse copyWith(
          void Function(CreatePhoneOrderResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePhoneOrderResponse))
          as CreatePhoneOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePhoneOrderResponse create() => CreatePhoneOrderResponse._();
  @$core.override
  CreatePhoneOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatePhoneOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePhoneOrderResponse>(create);
  static CreatePhoneOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  PhoneOrder get phoneOrder => $_getN(1);
  @$pb.TagNumber(2)
  set phoneOrder(PhoneOrder value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  PhoneOrder ensurePhoneOrder() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

class ListPhoneOrdersRequest extends $pb.GeneratedMessage {
  factory ListPhoneOrdersRequest() => create();

  ListPhoneOrdersRequest._();

  factory ListPhoneOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPhoneOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPhoneOrdersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhoneOrdersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhoneOrdersRequest copyWith(
          void Function(ListPhoneOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as ListPhoneOrdersRequest))
          as ListPhoneOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPhoneOrdersRequest create() => ListPhoneOrdersRequest._();
  @$core.override
  ListPhoneOrdersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPhoneOrdersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPhoneOrdersRequest>(create);
  static ListPhoneOrdersRequest? _defaultInstance;
}

class ListPhoneOrdersResponse extends $pb.GeneratedMessage {
  factory ListPhoneOrdersResponse({
    $core.Iterable<PhoneOrder>? orders,
  }) {
    final result = create();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  ListPhoneOrdersResponse._();

  factory ListPhoneOrdersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPhoneOrdersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPhoneOrdersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..pPM<PhoneOrder>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: PhoneOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhoneOrdersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPhoneOrdersResponse copyWith(
          void Function(ListPhoneOrdersResponse) updates) =>
      super.copyWith((message) => updates(message as ListPhoneOrdersResponse))
          as ListPhoneOrdersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPhoneOrdersResponse create() => ListPhoneOrdersResponse._();
  @$core.override
  ListPhoneOrdersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPhoneOrdersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPhoneOrdersResponse>(create);
  static ListPhoneOrdersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PhoneOrder> get orders => $_getList(0);
}

class PhoneOrderActionRequest extends $pb.GeneratedMessage {
  factory PhoneOrderActionRequest({
    $core.String? phoneOrderId,
    $core.String? action,
  }) {
    final result = create();
    if (phoneOrderId != null) result.phoneOrderId = phoneOrderId;
    if (action != null) result.action = action;
    return result;
  }

  PhoneOrderActionRequest._();

  factory PhoneOrderActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneOrderActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhoneOrderActionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phoneOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'action')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderActionRequest copyWith(
          void Function(PhoneOrderActionRequest) updates) =>
      super.copyWith((message) => updates(message as PhoneOrderActionRequest))
          as PhoneOrderActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneOrderActionRequest create() => PhoneOrderActionRequest._();
  @$core.override
  PhoneOrderActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhoneOrderActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneOrderActionRequest>(create);
  static PhoneOrderActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phoneOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set phoneOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoneOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoneOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get action => $_getSZ(1);
  @$pb.TagNumber(2)
  set action($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

class PhoneOrderActionResponse extends $pb.GeneratedMessage {
  factory PhoneOrderActionResponse({
    $core.bool? success,
    PhoneOrder? phoneOrder,
    Ticket? ticket,
    $core.String? error,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (phoneOrder != null) result.phoneOrder = phoneOrder;
    if (ticket != null) result.ticket = ticket;
    if (error != null) result.error = error;
    return result;
  }

  PhoneOrderActionResponse._();

  factory PhoneOrderActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneOrderActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhoneOrderActionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<PhoneOrder>(2, _omitFieldNames ? '' : 'phoneOrder',
        subBuilder: PhoneOrder.create)
    ..aOM<Ticket>(3, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderActionResponse copyWith(
          void Function(PhoneOrderActionResponse) updates) =>
      super.copyWith((message) => updates(message as PhoneOrderActionResponse))
          as PhoneOrderActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneOrderActionResponse create() => PhoneOrderActionResponse._();
  @$core.override
  PhoneOrderActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhoneOrderActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneOrderActionResponse>(create);
  static PhoneOrderActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  PhoneOrder get phoneOrder => $_getN(1);
  @$pb.TagNumber(2)
  set phoneOrder(PhoneOrder value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  PhoneOrder ensurePhoneOrder() => $_ensure(1);

  @$pb.TagNumber(3)
  Ticket get ticket => $_getN(2);
  @$pb.TagNumber(3)
  set ticket(Ticket value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTicket() => $_has(2);
  @$pb.TagNumber(3)
  void clearTicket() => $_clearField(3);
  @$pb.TagNumber(3)
  Ticket ensureTicket() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get error => $_getSZ(3);
  @$pb.TagNumber(4)
  set error($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);
}

class PhoneOrderCountRequest extends $pb.GeneratedMessage {
  factory PhoneOrderCountRequest() => create();

  PhoneOrderCountRequest._();

  factory PhoneOrderCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneOrderCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhoneOrderCountRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderCountRequest copyWith(
          void Function(PhoneOrderCountRequest) updates) =>
      super.copyWith((message) => updates(message as PhoneOrderCountRequest))
          as PhoneOrderCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneOrderCountRequest create() => PhoneOrderCountRequest._();
  @$core.override
  PhoneOrderCountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhoneOrderCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneOrderCountRequest>(create);
  static PhoneOrderCountRequest? _defaultInstance;
}

class PhoneOrderCountResponse extends $pb.GeneratedMessage {
  factory PhoneOrderCountResponse({
    $core.int? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  PhoneOrderCountResponse._();

  factory PhoneOrderCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhoneOrderCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhoneOrderCountResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneOrderCountResponse copyWith(
          void Function(PhoneOrderCountResponse) updates) =>
      super.copyWith((message) => updates(message as PhoneOrderCountResponse))
          as PhoneOrderCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneOrderCountResponse create() => PhoneOrderCountResponse._();
  @$core.override
  PhoneOrderCountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhoneOrderCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhoneOrderCountResponse>(create);
  static PhoneOrderCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get count => $_getIZ(0);
  @$pb.TagNumber(1)
  set count($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
}

class ShutdownRequest extends $pb.GeneratedMessage {
  factory ShutdownRequest() => create();

  ShutdownRequest._();

  factory ShutdownRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShutdownRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShutdownRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShutdownRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShutdownRequest copyWith(void Function(ShutdownRequest) updates) =>
      super.copyWith((message) => updates(message as ShutdownRequest))
          as ShutdownRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShutdownRequest create() => ShutdownRequest._();
  @$core.override
  ShutdownRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShutdownRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShutdownRequest>(create);
  static ShutdownRequest? _defaultInstance;
}

class ShutdownResponse extends $pb.GeneratedMessage {
  factory ShutdownResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  ShutdownResponse._();

  factory ShutdownResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShutdownResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShutdownResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'vt_proto'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShutdownResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShutdownResponse copyWith(void Function(ShutdownResponse) updates) =>
      super.copyWith((message) => updates(message as ShutdownResponse))
          as ShutdownResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShutdownResponse create() => ShutdownResponse._();
  @$core.override
  ShutdownResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShutdownResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShutdownResponse>(create);
  static ShutdownResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
