// This is a generated file - do not edit.
//
// Generated from pos_service.proto.

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

@$core.Deprecated('Use modifierActionDescriptor instead')
const ModifierAction$json = {
  '1': 'ModifierAction',
  '2': [
    {'1': 'MOD_NONE', '2': 0},
    {'1': 'MOD_NO', '2': 1},
    {'1': 'MOD_ADD', '2': 2},
    {'1': 'MOD_EXTRA', '2': 3},
    {'1': 'MOD_LIGHT', '2': 4},
    {'1': 'MOD_SIDE', '2': 5},
    {'1': 'MOD_DOUBLE', '2': 6},
  ],
};

/// Descriptor for `ModifierAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List modifierActionDescriptor = $convert.base64Decode(
    'Cg5Nb2RpZmllckFjdGlvbhIMCghNT0RfTk9ORRAAEgoKBk1PRF9OTxABEgsKB01PRF9BREQQAh'
    'INCglNT0RfRVhUUkEQAxINCglNT0RfTElHSFQQBBIMCghNT0RfU0lERRAFEg4KCk1PRF9ET1VC'
    'TEUQBg==');

@$core.Deprecated('Use modifierDescriptor instead')
const Modifier$json = {
  '1': 'Modifier',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price_cents', '3': 3, '4': 1, '5': 5, '10': 'priceCents'},
    {'1': 'is_default', '3': 4, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `Modifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modifierDescriptor = $convert.base64Decode(
    'CghNb2RpZmllchIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIfCgtwcmljZV'
    '9jZW50cxgDIAEoBVIKcHJpY2VDZW50cxIdCgppc19kZWZhdWx0GAQgASgIUglpc0RlZmF1bHQ=');

@$core.Deprecated('Use modifierGroupDescriptor instead')
const ModifierGroup$json = {
  '1': 'ModifierGroup',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'modifiers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.Modifier',
      '10': 'modifiers'
    },
    {'1': 'min_select', '3': 4, '4': 1, '5': 5, '10': 'minSelect'},
    {'1': 'max_select', '3': 5, '4': 1, '5': 5, '10': 'maxSelect'},
  ],
};

/// Descriptor for `ModifierGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modifierGroupDescriptor = $convert.base64Decode(
    'Cg1Nb2RpZmllckdyb3VwEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEjAKCW'
    '1vZGlmaWVycxgDIAMoCzISLnZ0X3Byb3RvLk1vZGlmaWVyUgltb2RpZmllcnMSHQoKbWluX3Nl'
    'bGVjdBgEIAEoBVIJbWluU2VsZWN0Eh0KCm1heF9zZWxlY3QYBSABKAVSCW1heFNlbGVjdA==');

@$core.Deprecated('Use appliedModifierDescriptor instead')
const AppliedModifier$json = {
  '1': 'AppliedModifier',
  '2': [
    {'1': 'modifier_id', '3': 1, '4': 1, '5': 9, '10': 'modifierId'},
    {'1': 'modifier_name', '3': 2, '4': 1, '5': 9, '10': 'modifierName'},
    {
      '1': 'action',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.vt_proto.ModifierAction',
      '10': 'action'
    },
    {
      '1': 'price_adjustment_cents',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'priceAdjustmentCents'
    },
  ],
};

/// Descriptor for `AppliedModifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appliedModifierDescriptor = $convert.base64Decode(
    'Cg9BcHBsaWVkTW9kaWZpZXISHwoLbW9kaWZpZXJfaWQYASABKAlSCm1vZGlmaWVySWQSIwoNbW'
    '9kaWZpZXJfbmFtZRgCIAEoCVIMbW9kaWZpZXJOYW1lEjAKBmFjdGlvbhgDIAEoDjIYLnZ0X3By'
    'b3RvLk1vZGlmaWVyQWN0aW9uUgZhY3Rpb24SNAoWcHJpY2VfYWRqdXN0bWVudF9jZW50cxgEIA'
    'EoBVIUcHJpY2VBZGp1c3RtZW50Q2VudHM=');

@$core.Deprecated('Use menuItemDescriptor instead')
const MenuItem$json = {
  '1': 'MenuItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price_cents', '3': 3, '4': 1, '5': 5, '10': 'priceCents'},
    {'1': 'category', '3': 4, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'modifier_groups',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.ModifierGroup',
      '10': 'modifierGroups'
    },
    {'1': 'send_to_kitchen', '3': 6, '4': 1, '5': 8, '10': 'sendToKitchen'},
  ],
};

/// Descriptor for `MenuItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuItemDescriptor = $convert.base64Decode(
    'CghNZW51SXRlbRIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIfCgtwcmljZV'
    '9jZW50cxgDIAEoBVIKcHJpY2VDZW50cxIaCghjYXRlZ29yeRgEIAEoCVIIY2F0ZWdvcnkSQAoP'
    'bW9kaWZpZXJfZ3JvdXBzGAUgAygLMhcudnRfcHJvdG8uTW9kaWZpZXJHcm91cFIObW9kaWZpZX'
    'JHcm91cHMSJgoPc2VuZF90b19raXRjaGVuGAYgASgIUg1zZW5kVG9LaXRjaGVu');

@$core.Deprecated('Use ticketItemDescriptor instead')
const TicketItem$json = {
  '1': 'TicketItem',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.MenuItem',
      '10': 'item'
    },
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'line_key', '3': 3, '4': 1, '5': 9, '10': 'lineKey'},
    {
      '1': 'modifiers',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.AppliedModifier',
      '10': 'modifiers'
    },
    {
      '1': 'special_instructions',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'specialInstructions'
    },
  ],
};

/// Descriptor for `TicketItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ticketItemDescriptor = $convert.base64Decode(
    'CgpUaWNrZXRJdGVtEiYKBGl0ZW0YASABKAsyEi52dF9wcm90by5NZW51SXRlbVIEaXRlbRIaCg'
    'hxdWFudGl0eRgCIAEoBVIIcXVhbnRpdHkSGQoIbGluZV9rZXkYAyABKAlSB2xpbmVLZXkSNwoJ'
    'bW9kaWZpZXJzGAQgAygLMhkudnRfcHJvdG8uQXBwbGllZE1vZGlmaWVyUgltb2RpZmllcnMSMQ'
    'oUc3BlY2lhbF9pbnN0cnVjdGlvbnMYBSABKAlSE3NwZWNpYWxJbnN0cnVjdGlvbnM=');

@$core.Deprecated('Use ticketDescriptor instead')
const Ticket$json = {
  '1': 'Ticket',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.TicketItem',
      '10': 'items'
    },
    {'1': 'subtotal', '3': 3, '4': 1, '5': 5, '10': 'subtotal'},
    {'1': 'tax', '3': 4, '4': 1, '5': 5, '10': 'tax'},
    {'1': 'total', '3': 5, '4': 1, '5': 5, '10': 'total'},
    {'1': 'status', '3': 6, '4': 1, '5': 9, '10': 'status'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'payments',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.Payment',
      '10': 'payments'
    },
    {'1': 'amount_paid', '3': 9, '4': 1, '5': 5, '10': 'amountPaid'},
    {'1': 'change_due', '3': 10, '4': 1, '5': 5, '10': 'changeDue'},
  ],
};

/// Descriptor for `Ticket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ticketDescriptor = $convert.base64Decode(
    'CgZUaWNrZXQSDgoCaWQYASABKAlSAmlkEioKBWl0ZW1zGAIgAygLMhQudnRfcHJvdG8uVGlja2'
    'V0SXRlbVIFaXRlbXMSGgoIc3VidG90YWwYAyABKAVSCHN1YnRvdGFsEhAKA3RheBgEIAEoBVID'
    'dGF4EhQKBXRvdGFsGAUgASgFUgV0b3RhbBIWCgZzdGF0dXMYBiABKAlSBnN0YXR1cxIdCgpjcm'
    'VhdGVkX2F0GAcgASgDUgljcmVhdGVkQXQSLQoIcGF5bWVudHMYCCADKAsyES52dF9wcm90by5Q'
    'YXltZW50UghwYXltZW50cxIfCgthbW91bnRfcGFpZBgJIAEoBVIKYW1vdW50UGFpZBIdCgpjaG'
    'FuZ2VfZHVlGAogASgFUgljaGFuZ2VEdWU=');

@$core.Deprecated('Use paymentDescriptor instead')
const Payment$json = {
  '1': 'Payment',
  '2': [
    {'1': 'payment_type', '3': 1, '4': 1, '5': 9, '10': 'paymentType'},
    {'1': 'amount_cents', '3': 2, '4': 1, '5': 5, '10': 'amountCents'},
  ],
};

/// Descriptor for `Payment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentDescriptor = $convert.base64Decode(
    'CgdQYXltZW50EiEKDHBheW1lbnRfdHlwZRgBIAEoCVILcGF5bWVudFR5cGUSIQoMYW1vdW50X2'
    'NlbnRzGAIgASgFUgthbW91bnRDZW50cw==');

@$core.Deprecated('Use addItemRequestDescriptor instead')
const AddItemRequest$json = {
  '1': 'AddItemRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'menu_item_id', '3': 2, '4': 1, '5': 9, '10': 'menuItemId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'modifiers',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.AppliedModifier',
      '10': 'modifiers'
    },
    {
      '1': 'special_instructions',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'specialInstructions'
    },
  ],
};

/// Descriptor for `AddItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addItemRequestDescriptor = $convert.base64Decode(
    'Cg5BZGRJdGVtUmVxdWVzdBIbCgl0aWNrZXRfaWQYASABKAlSCHRpY2tldElkEiAKDG1lbnVfaX'
    'RlbV9pZBgCIAEoCVIKbWVudUl0ZW1JZBIaCghxdWFudGl0eRgDIAEoBVIIcXVhbnRpdHkSNwoJ'
    'bW9kaWZpZXJzGAQgAygLMhkudnRfcHJvdG8uQXBwbGllZE1vZGlmaWVyUgltb2RpZmllcnMSMQ'
    'oUc3BlY2lhbF9pbnN0cnVjdGlvbnMYBSABKAlSE3NwZWNpYWxJbnN0cnVjdGlvbnM=');

@$core.Deprecated('Use addItemResponseDescriptor instead')
const AddItemResponse$json = {
  '1': 'AddItemResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `AddItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addItemResponseDescriptor = $convert.base64Decode(
    'Cg9BZGRJdGVtUmVzcG9uc2USKAoGdGlja2V0GAEgASgLMhAudnRfcHJvdG8uVGlja2V0UgZ0aW'
    'NrZXQ=');

@$core.Deprecated('Use removeItemRequestDescriptor instead')
const RemoveItemRequest$json = {
  '1': 'RemoveItemRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'menu_item_id', '3': 2, '4': 1, '5': 9, '10': 'menuItemId'},
    {'1': 'line_key', '3': 3, '4': 1, '5': 9, '10': 'lineKey'},
  ],
};

/// Descriptor for `RemoveItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeItemRequestDescriptor = $convert.base64Decode(
    'ChFSZW1vdmVJdGVtUmVxdWVzdBIbCgl0aWNrZXRfaWQYASABKAlSCHRpY2tldElkEiAKDG1lbn'
    'VfaXRlbV9pZBgCIAEoCVIKbWVudUl0ZW1JZBIZCghsaW5lX2tleRgDIAEoCVIHbGluZUtleQ==');

@$core.Deprecated('Use removeItemResponseDescriptor instead')
const RemoveItemResponse$json = {
  '1': 'RemoveItemResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `RemoveItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeItemResponseDescriptor = $convert.base64Decode(
    'ChJSZW1vdmVJdGVtUmVzcG9uc2USKAoGdGlja2V0GAEgASgLMhAudnRfcHJvdG8uVGlja2V0Ug'
    'Z0aWNrZXQ=');

@$core.Deprecated('Use updateItemRequestDescriptor instead')
const UpdateItemRequest$json = {
  '1': 'UpdateItemRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'line_key', '3': 2, '4': 1, '5': 9, '10': 'lineKey'},
    {
      '1': 'modifiers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.AppliedModifier',
      '10': 'modifiers'
    },
    {
      '1': 'special_instructions',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'specialInstructions'
    },
  ],
};

/// Descriptor for `UpdateItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateItemRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVJdGVtUmVxdWVzdBIbCgl0aWNrZXRfaWQYASABKAlSCHRpY2tldElkEhkKCGxpbm'
    'Vfa2V5GAIgASgJUgdsaW5lS2V5EjcKCW1vZGlmaWVycxgDIAMoCzIZLnZ0X3Byb3RvLkFwcGxp'
    'ZWRNb2RpZmllclIJbW9kaWZpZXJzEjEKFHNwZWNpYWxfaW5zdHJ1Y3Rpb25zGAQgASgJUhNzcG'
    'VjaWFsSW5zdHJ1Y3Rpb25z');

@$core.Deprecated('Use updateItemResponseDescriptor instead')
const UpdateItemResponse$json = {
  '1': 'UpdateItemResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `UpdateItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateItemResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVJdGVtUmVzcG9uc2USKAoGdGlja2V0GAEgASgLMhAudnRfcHJvdG8uVGlja2V0Ug'
    'Z0aWNrZXQ=');

@$core.Deprecated('Use decreaseItemRequestDescriptor instead')
const DecreaseItemRequest$json = {
  '1': 'DecreaseItemRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'menu_item_id', '3': 2, '4': 1, '5': 9, '10': 'menuItemId'},
    {'1': 'line_key', '3': 3, '4': 1, '5': 9, '10': 'lineKey'},
  ],
};

/// Descriptor for `DecreaseItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decreaseItemRequestDescriptor = $convert.base64Decode(
    'ChNEZWNyZWFzZUl0ZW1SZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQSIAoMbW'
    'VudV9pdGVtX2lkGAIgASgJUgptZW51SXRlbUlkEhkKCGxpbmVfa2V5GAMgASgJUgdsaW5lS2V5');

@$core.Deprecated('Use decreaseItemResponseDescriptor instead')
const DecreaseItemResponse$json = {
  '1': 'DecreaseItemResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `DecreaseItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decreaseItemResponseDescriptor = $convert.base64Decode(
    'ChREZWNyZWFzZUl0ZW1SZXNwb25zZRIoCgZ0aWNrZXQYASABKAsyEC52dF9wcm90by5UaWNrZX'
    'RSBnRpY2tldA==');

@$core.Deprecated('Use getTicketRequestDescriptor instead')
const GetTicketRequest$json = {
  '1': 'GetTicketRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
  ],
};

/// Descriptor for `GetTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTicketRequestDescriptor = $convert.base64Decode(
    'ChBHZXRUaWNrZXRSZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQ=');

@$core.Deprecated('Use getTicketResponseDescriptor instead')
const GetTicketResponse$json = {
  '1': 'GetTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `GetTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTicketResponseDescriptor = $convert.base64Decode(
    'ChFHZXRUaWNrZXRSZXNwb25zZRIoCgZ0aWNrZXQYASABKAsyEC52dF9wcm90by5UaWNrZXRSBn'
    'RpY2tldA==');

@$core.Deprecated('Use newTicketRequestDescriptor instead')
const NewTicketRequest$json = {
  '1': 'NewTicketRequest',
};

/// Descriptor for `NewTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newTicketRequestDescriptor =
    $convert.base64Decode('ChBOZXdUaWNrZXRSZXF1ZXN0');

@$core.Deprecated('Use newTicketResponseDescriptor instead')
const NewTicketResponse$json = {
  '1': 'NewTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `NewTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newTicketResponseDescriptor = $convert.base64Decode(
    'ChFOZXdUaWNrZXRSZXNwb25zZRIoCgZ0aWNrZXQYASABKAsyEC52dF9wcm90by5UaWNrZXRSBn'
    'RpY2tldA==');

@$core.Deprecated('Use checkoutRequestDescriptor instead')
const CheckoutRequest$json = {
  '1': 'CheckoutRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {
      '1': 'payments',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.Payment',
      '10': 'payments'
    },
  ],
};

/// Descriptor for `CheckoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkoutRequestDescriptor = $convert.base64Decode(
    'Cg9DaGVja291dFJlcXVlc3QSGwoJdGlja2V0X2lkGAEgASgJUgh0aWNrZXRJZBItCghwYXltZW'
    '50cxgCIAMoCzIRLnZ0X3Byb3RvLlBheW1lbnRSCHBheW1lbnRz');

@$core.Deprecated('Use checkoutResponseDescriptor instead')
const CheckoutResponse$json = {
  '1': 'CheckoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'ticket',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `CheckoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkoutResponseDescriptor = $convert.base64Decode(
    'ChBDaGVja291dFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSKAoGdGlja2V0GA'
    'IgASgLMhAudnRfcHJvdG8uVGlja2V0UgZ0aWNrZXQSFAoFZXJyb3IYAyABKAlSBWVycm9y');

@$core.Deprecated('Use listTicketsRequestDescriptor instead')
const ListTicketsRequest$json = {
  '1': 'ListTicketsRequest',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `ListTicketsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTicketsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0VGlja2V0c1JlcXVlc3QSEgoEZGF0ZRgBIAEoCVIEZGF0ZRIWCgZzdGF0dXMYAiABKA'
    'lSBnN0YXR1cw==');

@$core.Deprecated('Use listTicketsResponseDescriptor instead')
const ListTicketsResponse$json = {
  '1': 'ListTicketsResponse',
  '2': [
    {
      '1': 'tickets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'tickets'
    },
  ],
};

/// Descriptor for `ListTicketsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTicketsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0VGlja2V0c1Jlc3BvbnNlEioKB3RpY2tldHMYASADKAsyEC52dF9wcm90by5UaWNrZX'
    'RSB3RpY2tldHM=');

@$core.Deprecated('Use ticketActionRequestDescriptor instead')
const TicketActionRequest$json = {
  '1': 'TicketActionRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'action', '3': 2, '4': 1, '5': 9, '10': 'action'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `TicketActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ticketActionRequestDescriptor = $convert.base64Decode(
    'ChNUaWNrZXRBY3Rpb25SZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQSFgoGYW'
    'N0aW9uGAIgASgJUgZhY3Rpb24SFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use ticketActionResponseDescriptor instead')
const TicketActionResponse$json = {
  '1': 'TicketActionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'ticket',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `TicketActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ticketActionResponseDescriptor = $convert.base64Decode(
    'ChRUaWNrZXRBY3Rpb25SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEigKBnRpY2'
    'tldBgCIAEoCzIQLnZ0X3Byb3RvLlRpY2tldFIGdGlja2V0EhQKBWVycm9yGAMgASgJUgVlcnJv'
    'cg==');

@$core.Deprecated('Use printReceiptRequestDescriptor instead')
const PrintReceiptRequest$json = {
  '1': 'PrintReceiptRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
  ],
};

/// Descriptor for `PrintReceiptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printReceiptRequestDescriptor =
    $convert.base64Decode(
        'ChNQcmludFJlY2VpcHRSZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQ=');

@$core.Deprecated('Use printReceiptResponseDescriptor instead')
const PrintReceiptResponse$json = {
  '1': 'PrintReceiptResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
    {'1': 'job_id', '3': 3, '4': 1, '5': 5, '10': 'jobId'},
  ],
};

/// Descriptor for `PrintReceiptResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printReceiptResponseDescriptor = $convert.base64Decode(
    'ChRQcmludFJlY2VpcHRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhQKBWVycm'
    '9yGAIgASgJUgVlcnJvchIVCgZqb2JfaWQYAyABKAVSBWpvYklk');

@$core.Deprecated('Use printStatusEventDescriptor instead')
const PrintStatusEvent$json = {
  '1': 'PrintStatusEvent',
  '2': [
    {'1': 'job_id', '3': 1, '4': 1, '5': 5, '10': 'jobId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PrintStatusEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printStatusEventDescriptor = $convert.base64Decode(
    'ChBQcmludFN0YXR1c0V2ZW50EhUKBmpvYl9pZBgBIAEoBVIFam9iSWQSFgoGc3RhdHVzGAIgAS'
    'gJUgZzdGF0dXMSGAoHbWVzc2FnZRgDIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use getMenuRequestDescriptor instead')
const GetMenuRequest$json = {
  '1': 'GetMenuRequest',
};

/// Descriptor for `GetMenuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMenuRequestDescriptor =
    $convert.base64Decode('Cg5HZXRNZW51UmVxdWVzdA==');

@$core.Deprecated('Use getMenuResponseDescriptor instead')
const GetMenuResponse$json = {
  '1': 'GetMenuResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.MenuItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `GetMenuResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMenuResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRNZW51UmVzcG9uc2USKAoFaXRlbXMYASADKAsyEi52dF9wcm90by5NZW51SXRlbVIFaX'
    'RlbXM=');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {'1': 'restaurant_name', '3': 1, '4': 1, '5': 9, '10': 'restaurantName'},
    {'1': 'tax_rate_bps', '3': 2, '4': 1, '5': 5, '10': 'taxRateBps'},
    {
      '1': 'receipt_printer_name',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'receiptPrinterName'
    },
    {
      '1': 'receipt_printer_enabled',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'receiptPrinterEnabled'
    },
    {
      '1': 'kitchen_printer_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'kitchenPrinterName'
    },
    {
      '1': 'kitchen_printer_enabled',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'kitchenPrinterEnabled'
    },
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxInCg9yZXN0YXVyYW50X25hbWUYASABKAlSDnJlc3RhdXJhbnROYW1lEiAKDH'
    'RheF9yYXRlX2JwcxgCIAEoBVIKdGF4UmF0ZUJwcxIwChRyZWNlaXB0X3ByaW50ZXJfbmFtZRgD'
    'IAEoCVIScmVjZWlwdFByaW50ZXJOYW1lEjYKF3JlY2VpcHRfcHJpbnRlcl9lbmFibGVkGAQgAS'
    'gIUhVyZWNlaXB0UHJpbnRlckVuYWJsZWQSMAoUa2l0Y2hlbl9wcmludGVyX25hbWUYBSABKAlS'
    'EmtpdGNoZW5QcmludGVyTmFtZRI2ChdraXRjaGVuX3ByaW50ZXJfZW5hYmxlZBgGIAEoCFIVa2'
    'l0Y2hlblByaW50ZXJFbmFibGVk');

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor =
    $convert.base64Decode('ChJHZXRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use getSettingsResponseDescriptor instead')
const GetSettingsResponse$json = {
  '1': 'GetSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `GetSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTZXR0aW5nc1Jlc3BvbnNlEi4KCHNldHRpbmdzGAEgASgLMhIudnRfcHJvdG8uU2V0dG'
    'luZ3NSCHNldHRpbmdz');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSLgoIc2V0dGluZ3MYASABKAsyEi52dF9wcm90by5TZX'
    'R0aW5nc1IIc2V0dGluZ3M=');

@$core.Deprecated('Use updateSettingsResponseDescriptor instead')
const UpdateSettingsResponse$json = {
  '1': 'UpdateSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Settings',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `UpdateSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVTZXR0aW5nc1Jlc3BvbnNlEi4KCHNldHRpbmdzGAEgASgLMhIudnRfcHJvdG8uU2'
        'V0dGluZ3NSCHNldHRpbmdz');

@$core.Deprecated('Use printerInfoDescriptor instead')
const PrinterInfo$json = {
  '1': 'PrinterInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'is_default', '3': 4, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `PrinterInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printerInfoDescriptor = $convert.base64Decode(
    'CgtQcmludGVySW5mbxISCgRuYW1lGAEgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGAIgASgJUg'
    'tkZXNjcmlwdGlvbhIQCgN1cmkYAyABKAlSA3VyaRIdCgppc19kZWZhdWx0GAQgASgIUglpc0Rl'
    'ZmF1bHQ=');

@$core.Deprecated('Use listPrintersRequestDescriptor instead')
const ListPrintersRequest$json = {
  '1': 'ListPrintersRequest',
};

/// Descriptor for `ListPrintersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPrintersRequestDescriptor =
    $convert.base64Decode('ChNMaXN0UHJpbnRlcnNSZXF1ZXN0');

@$core.Deprecated('Use listPrintersResponseDescriptor instead')
const ListPrintersResponse$json = {
  '1': 'ListPrintersResponse',
  '2': [
    {
      '1': 'printers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.PrinterInfo',
      '10': 'printers'
    },
  ],
};

/// Descriptor for `ListPrintersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPrintersResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJpbnRlcnNSZXNwb25zZRIxCghwcmludGVycxgBIAMoCzIVLnZ0X3Byb3RvLlByaW'
    '50ZXJJbmZvUghwcmludGVycw==');

@$core.Deprecated('Use printKitchenRequestDescriptor instead')
const PrintKitchenRequest$json = {
  '1': 'PrintKitchenRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
  ],
};

/// Descriptor for `PrintKitchenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printKitchenRequestDescriptor =
    $convert.base64Decode(
        'ChNQcmludEtpdGNoZW5SZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQ=');

@$core.Deprecated('Use printKitchenResponseDescriptor instead')
const PrintKitchenResponse$json = {
  '1': 'PrintKitchenResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
    {'1': 'job_id', '3': 3, '4': 1, '5': 5, '10': 'jobId'},
  ],
};

/// Descriptor for `PrintKitchenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printKitchenResponseDescriptor = $convert.base64Decode(
    'ChRQcmludEtpdGNoZW5SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhQKBWVycm'
    '9yGAIgASgJUgVlcnJvchIVCgZqb2JfaWQYAyABKAVSBWpvYklk');

@$core.Deprecated('Use addMenuItemRequestDescriptor instead')
const AddMenuItemRequest$json = {
  '1': 'AddMenuItemRequest',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.MenuItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `AddMenuItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMenuItemRequestDescriptor = $convert.base64Decode(
    'ChJBZGRNZW51SXRlbVJlcXVlc3QSJgoEaXRlbRgBIAEoCzISLnZ0X3Byb3RvLk1lbnVJdGVtUg'
    'RpdGVt');

@$core.Deprecated('Use addMenuItemResponseDescriptor instead')
const AddMenuItemResponse$json = {
  '1': 'AddMenuItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.MenuItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `AddMenuItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMenuItemResponseDescriptor = $convert.base64Decode(
    'ChNBZGRNZW51SXRlbVJlc3BvbnNlEiYKBGl0ZW0YASABKAsyEi52dF9wcm90by5NZW51SXRlbV'
    'IEaXRlbQ==');

@$core.Deprecated('Use updateMenuItemRequestDescriptor instead')
const UpdateMenuItemRequest$json = {
  '1': 'UpdateMenuItemRequest',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.MenuItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `UpdateMenuItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMenuItemRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVNZW51SXRlbVJlcXVlc3QSJgoEaXRlbRgBIAEoCzISLnZ0X3Byb3RvLk1lbnVJdG'
    'VtUgRpdGVt');

@$core.Deprecated('Use updateMenuItemResponseDescriptor instead')
const UpdateMenuItemResponse$json = {
  '1': 'UpdateMenuItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.MenuItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `UpdateMenuItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMenuItemResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVNZW51SXRlbVJlc3BvbnNlEiYKBGl0ZW0YASABKAsyEi52dF9wcm90by5NZW51SX'
        'RlbVIEaXRlbQ==');

@$core.Deprecated('Use deleteMenuItemRequestDescriptor instead')
const DeleteMenuItemRequest$json = {
  '1': 'DeleteMenuItemRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `DeleteMenuItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMenuItemRequestDescriptor =
    $convert.base64Decode(
        'ChVEZWxldGVNZW51SXRlbVJlcXVlc3QSFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlk');

@$core.Deprecated('Use deleteMenuItemResponseDescriptor instead')
const DeleteMenuItemResponse$json = {
  '1': 'DeleteMenuItemResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteMenuItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMenuItemResponseDescriptor =
    $convert.base64Decode(
        'ChZEZWxldGVNZW51SXRlbVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use itemSalesEntryDescriptor instead')
const ItemSalesEntry$json = {
  '1': 'ItemSalesEntry',
  '2': [
    {'1': 'item_name', '3': 1, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'quantity_sold', '3': 2, '4': 1, '5': 5, '10': 'quantitySold'},
    {'1': 'revenue_cents', '3': 3, '4': 1, '5': 5, '10': 'revenueCents'},
  ],
};

/// Descriptor for `ItemSalesEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemSalesEntryDescriptor = $convert.base64Decode(
    'Cg5JdGVtU2FsZXNFbnRyeRIbCglpdGVtX25hbWUYASABKAlSCGl0ZW1OYW1lEiMKDXF1YW50aX'
    'R5X3NvbGQYAiABKAVSDHF1YW50aXR5U29sZBIjCg1yZXZlbnVlX2NlbnRzGAMgASgFUgxyZXZl'
    'bnVlQ2VudHM=');

@$core.Deprecated('Use dailyReportDescriptor instead')
const DailyReport$json = {
  '1': 'DailyReport',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'total_tickets', '3': 2, '4': 1, '5': 5, '10': 'totalTickets'},
    {
      '1': 'total_revenue_cents',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'totalRevenueCents'
    },
    {'1': 'total_tax_cents', '3': 4, '4': 1, '5': 5, '10': 'totalTaxCents'},
    {'1': 'cash_count', '3': 5, '4': 1, '5': 5, '10': 'cashCount'},
    {'1': 'card_count', '3': 6, '4': 1, '5': 5, '10': 'cardCount'},
    {'1': 'voided_count', '3': 7, '4': 1, '5': 5, '10': 'voidedCount'},
    {
      '1': 'item_sales',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.ItemSalesEntry',
      '10': 'itemSales'
    },
    {'1': 'comped_count', '3': 9, '4': 1, '5': 5, '10': 'compedCount'},
    {'1': 'refunded_count', '3': 10, '4': 1, '5': 5, '10': 'refundedCount'},
    {'1': 'cash_total_cents', '3': 11, '4': 1, '5': 5, '10': 'cashTotalCents'},
    {'1': 'card_total_cents', '3': 12, '4': 1, '5': 5, '10': 'cardTotalCents'},
    {
      '1': 'comped_total_cents',
      '3': 13,
      '4': 1,
      '5': 5,
      '10': 'compedTotalCents'
    },
    {
      '1': 'refunded_total_cents',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'refundedTotalCents'
    },
    {
      '1': 'net_revenue_cents',
      '3': 15,
      '4': 1,
      '5': 5,
      '10': 'netRevenueCents'
    },
  ],
};

/// Descriptor for `DailyReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyReportDescriptor = $convert.base64Decode(
    'CgtEYWlseVJlcG9ydBISCgRkYXRlGAEgASgJUgRkYXRlEiMKDXRvdGFsX3RpY2tldHMYAiABKA'
    'VSDHRvdGFsVGlja2V0cxIuChN0b3RhbF9yZXZlbnVlX2NlbnRzGAMgASgFUhF0b3RhbFJldmVu'
    'dWVDZW50cxImCg90b3RhbF90YXhfY2VudHMYBCABKAVSDXRvdGFsVGF4Q2VudHMSHQoKY2FzaF'
    '9jb3VudBgFIAEoBVIJY2FzaENvdW50Eh0KCmNhcmRfY291bnQYBiABKAVSCWNhcmRDb3VudBIh'
    'Cgx2b2lkZWRfY291bnQYByABKAVSC3ZvaWRlZENvdW50EjcKCml0ZW1fc2FsZXMYCCADKAsyGC'
    '52dF9wcm90by5JdGVtU2FsZXNFbnRyeVIJaXRlbVNhbGVzEiEKDGNvbXBlZF9jb3VudBgJIAEo'
    'BVILY29tcGVkQ291bnQSJQoOcmVmdW5kZWRfY291bnQYCiABKAVSDXJlZnVuZGVkQ291bnQSKA'
    'oQY2FzaF90b3RhbF9jZW50cxgLIAEoBVIOY2FzaFRvdGFsQ2VudHMSKAoQY2FyZF90b3RhbF9j'
    'ZW50cxgMIAEoBVIOY2FyZFRvdGFsQ2VudHMSLAoSY29tcGVkX3RvdGFsX2NlbnRzGA0gASgFUh'
    'Bjb21wZWRUb3RhbENlbnRzEjAKFHJlZnVuZGVkX3RvdGFsX2NlbnRzGA4gASgFUhJyZWZ1bmRl'
    'ZFRvdGFsQ2VudHMSKgoRbmV0X3JldmVudWVfY2VudHMYDyABKAVSD25ldFJldmVudWVDZW50cw'
    '==');

@$core.Deprecated('Use dailyReportRequestDescriptor instead')
const DailyReportRequest$json = {
  '1': 'DailyReportRequest',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
  ],
};

/// Descriptor for `DailyReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyReportRequestDescriptor = $convert
    .base64Decode('ChJEYWlseVJlcG9ydFJlcXVlc3QSEgoEZGF0ZRgBIAEoCVIEZGF0ZQ==');

@$core.Deprecated('Use dailyReportResponseDescriptor instead')
const DailyReportResponse$json = {
  '1': 'DailyReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.DailyReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `DailyReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyReportResponseDescriptor = $convert.base64Decode(
    'ChNEYWlseVJlcG9ydFJlc3BvbnNlEi0KBnJlcG9ydBgBIAEoCzIVLnZ0X3Byb3RvLkRhaWx5Um'
    'Vwb3J0UgZyZXBvcnQ=');

@$core.Deprecated('Use reportHistoryRequestDescriptor instead')
const ReportHistoryRequest$json = {
  '1': 'ReportHistoryRequest',
  '2': [
    {'1': 'days_back', '3': 1, '4': 1, '5': 5, '10': 'daysBack'},
  ],
};

/// Descriptor for `ReportHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportHistoryRequestDescriptor =
    $convert.base64Decode(
        'ChRSZXBvcnRIaXN0b3J5UmVxdWVzdBIbCglkYXlzX2JhY2sYASABKAVSCGRheXNCYWNr');

@$core.Deprecated('Use reportHistoryResponseDescriptor instead')
const ReportHistoryResponse$json = {
  '1': 'ReportHistoryResponse',
  '2': [
    {
      '1': 'reports',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.DailyReport',
      '10': 'reports'
    },
  ],
};

/// Descriptor for `ReportHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportHistoryResponseDescriptor = $convert.base64Decode(
    'ChVSZXBvcnRIaXN0b3J5UmVzcG9uc2USLwoHcmVwb3J0cxgBIAMoCzIVLnZ0X3Byb3RvLkRhaW'
    'x5UmVwb3J0UgdyZXBvcnRz');

@$core.Deprecated('Use dateRangeReportRequestDescriptor instead')
const DateRangeReportRequest$json = {
  '1': 'DateRangeReportRequest',
  '2': [
    {'1': 'start_date', '3': 1, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 2, '4': 1, '5': 9, '10': 'endDate'},
  ],
};

/// Descriptor for `DateRangeReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateRangeReportRequestDescriptor =
    $convert.base64Decode(
        'ChZEYXRlUmFuZ2VSZXBvcnRSZXF1ZXN0Eh0KCnN0YXJ0X2RhdGUYASABKAlSCXN0YXJ0RGF0ZR'
        'IZCghlbmRfZGF0ZRgCIAEoCVIHZW5kRGF0ZQ==');

@$core.Deprecated('Use dateRangeReportResponseDescriptor instead')
const DateRangeReportResponse$json = {
  '1': 'DateRangeReportResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.DailyReport',
      '10': 'summary'
    },
    {
      '1': 'daily_reports',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.DailyReport',
      '10': 'dailyReports'
    },
  ],
};

/// Descriptor for `DateRangeReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateRangeReportResponseDescriptor = $convert.base64Decode(
    'ChdEYXRlUmFuZ2VSZXBvcnRSZXNwb25zZRIvCgdzdW1tYXJ5GAEgASgLMhUudnRfcHJvdG8uRG'
    'FpbHlSZXBvcnRSB3N1bW1hcnkSOgoNZGFpbHlfcmVwb3J0cxgCIAMoCzIVLnZ0X3Byb3RvLkRh'
    'aWx5UmVwb3J0UgxkYWlseVJlcG9ydHM=');

@$core.Deprecated('Use printReportRequestDescriptor instead')
const PrintReportRequest$json = {
  '1': 'PrintReportRequest',
  '2': [
    {'1': 'report_type', '3': 1, '4': 1, '5': 9, '10': 'reportType'},
    {'1': 'date', '3': 2, '4': 1, '5': 9, '10': 'date'},
    {'1': 'start_date', '3': 3, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 4, '4': 1, '5': 9, '10': 'endDate'},
  ],
};

/// Descriptor for `PrintReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printReportRequestDescriptor = $convert.base64Decode(
    'ChJQcmludFJlcG9ydFJlcXVlc3QSHwoLcmVwb3J0X3R5cGUYASABKAlSCnJlcG9ydFR5cGUSEg'
    'oEZGF0ZRgCIAEoCVIEZGF0ZRIdCgpzdGFydF9kYXRlGAMgASgJUglzdGFydERhdGUSGQoIZW5k'
    'X2RhdGUYBCABKAlSB2VuZERhdGU=');

@$core.Deprecated('Use printReportResponseDescriptor instead')
const PrintReportResponse$json = {
  '1': 'PrintReportResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
    {'1': 'job_id', '3': 3, '4': 1, '5': 5, '10': 'jobId'},
  ],
};

/// Descriptor for `PrintReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List printReportResponseDescriptor = $convert.base64Decode(
    'ChNQcmludFJlcG9ydFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSFAoFZXJyb3'
    'IYAiABKAlSBWVycm9yEhUKBmpvYl9pZBgDIAEoBVIFam9iSWQ=');

@$core.Deprecated('Use endDayRequestDescriptor instead')
const EndDayRequest$json = {
  '1': 'EndDayRequest',
};

/// Descriptor for `EndDayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endDayRequestDescriptor =
    $convert.base64Decode('Cg1FbmREYXlSZXF1ZXN0');

@$core.Deprecated('Use endDayResponseDescriptor instead')
const EndDayResponse$json = {
  '1': 'EndDayResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'z_report',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.DailyReport',
      '10': 'zReport'
    },
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `EndDayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endDayResponseDescriptor = $convert.base64Decode(
    'Cg5FbmREYXlSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEjAKCHpfcmVwb3J0GA'
    'IgASgLMhUudnRfcHJvdG8uRGFpbHlSZXBvcnRSB3pSZXBvcnQSFAoFZXJyb3IYAyABKAlSBWVy'
    'cm9y');

@$core.Deprecated('Use phoneOrderDescriptor instead')
const PhoneOrder$json = {
  '1': 'PhoneOrder',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'ticket',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
    {'1': 'customer_name', '3': 3, '4': 1, '5': 9, '10': 'customerName'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `PhoneOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneOrderDescriptor = $convert.base64Decode(
    'CgpQaG9uZU9yZGVyEg4KAmlkGAEgASgJUgJpZBIoCgZ0aWNrZXQYAiABKAsyEC52dF9wcm90by'
    '5UaWNrZXRSBnRpY2tldBIjCg1jdXN0b21lcl9uYW1lGAMgASgJUgxjdXN0b21lck5hbWUSGAoH'
    'Y29tbWVudBgEIAEoCVIHY29tbWVudBIWCgZzdGF0dXMYBSABKAlSBnN0YXR1cxIdCgpjcmVhdG'
    'VkX2F0GAYgASgDUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use createPhoneOrderRequestDescriptor instead')
const CreatePhoneOrderRequest$json = {
  '1': 'CreatePhoneOrderRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'customer_name', '3': 2, '4': 1, '5': 9, '10': 'customerName'},
    {'1': 'comment', '3': 3, '4': 1, '5': 9, '10': 'comment'},
  ],
};

/// Descriptor for `CreatePhoneOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPhoneOrderRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVQaG9uZU9yZGVyUmVxdWVzdBIbCgl0aWNrZXRfaWQYASABKAlSCHRpY2tldElkEi'
    'MKDWN1c3RvbWVyX25hbWUYAiABKAlSDGN1c3RvbWVyTmFtZRIYCgdjb21tZW50GAMgASgJUgdj'
    'b21tZW50');

@$core.Deprecated('Use createPhoneOrderResponseDescriptor instead')
const CreatePhoneOrderResponse$json = {
  '1': 'CreatePhoneOrderResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'phone_order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.PhoneOrder',
      '10': 'phoneOrder'
    },
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `CreatePhoneOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPhoneOrderResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVQaG9uZU9yZGVyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxI1Cg'
    'twaG9uZV9vcmRlchgCIAEoCzIULnZ0X3Byb3RvLlBob25lT3JkZXJSCnBob25lT3JkZXISFAoF'
    'ZXJyb3IYAyABKAlSBWVycm9y');

@$core.Deprecated('Use listPhoneOrdersRequestDescriptor instead')
const ListPhoneOrdersRequest$json = {
  '1': 'ListPhoneOrdersRequest',
};

/// Descriptor for `ListPhoneOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhoneOrdersRequestDescriptor =
    $convert.base64Decode('ChZMaXN0UGhvbmVPcmRlcnNSZXF1ZXN0');

@$core.Deprecated('Use listPhoneOrdersResponseDescriptor instead')
const ListPhoneOrdersResponse$json = {
  '1': 'ListPhoneOrdersResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.vt_proto.PhoneOrder',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `ListPhoneOrdersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhoneOrdersResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UGhvbmVPcmRlcnNSZXNwb25zZRIsCgZvcmRlcnMYASADKAsyFC52dF9wcm90by5QaG'
        '9uZU9yZGVyUgZvcmRlcnM=');

@$core.Deprecated('Use phoneOrderActionRequestDescriptor instead')
const PhoneOrderActionRequest$json = {
  '1': 'PhoneOrderActionRequest',
  '2': [
    {'1': 'phone_order_id', '3': 1, '4': 1, '5': 9, '10': 'phoneOrderId'},
    {'1': 'action', '3': 2, '4': 1, '5': 9, '10': 'action'},
  ],
};

/// Descriptor for `PhoneOrderActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneOrderActionRequestDescriptor =
    $convert.base64Decode(
        'ChdQaG9uZU9yZGVyQWN0aW9uUmVxdWVzdBIkCg5waG9uZV9vcmRlcl9pZBgBIAEoCVIMcGhvbm'
        'VPcmRlcklkEhYKBmFjdGlvbhgCIAEoCVIGYWN0aW9u');

@$core.Deprecated('Use phoneOrderActionResponseDescriptor instead')
const PhoneOrderActionResponse$json = {
  '1': 'PhoneOrderActionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'phone_order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.PhoneOrder',
      '10': 'phoneOrder'
    },
    {
      '1': 'ticket',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.vt_proto.Ticket',
      '10': 'ticket'
    },
    {'1': 'error', '3': 4, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `PhoneOrderActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneOrderActionResponseDescriptor = $convert.base64Decode(
    'ChhQaG9uZU9yZGVyQWN0aW9uUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxI1Cg'
    'twaG9uZV9vcmRlchgCIAEoCzIULnZ0X3Byb3RvLlBob25lT3JkZXJSCnBob25lT3JkZXISKAoG'
    'dGlja2V0GAMgASgLMhAudnRfcHJvdG8uVGlja2V0UgZ0aWNrZXQSFAoFZXJyb3IYBCABKAlSBW'
    'Vycm9y');

@$core.Deprecated('Use phoneOrderCountRequestDescriptor instead')
const PhoneOrderCountRequest$json = {
  '1': 'PhoneOrderCountRequest',
};

/// Descriptor for `PhoneOrderCountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneOrderCountRequestDescriptor =
    $convert.base64Decode('ChZQaG9uZU9yZGVyQ291bnRSZXF1ZXN0');

@$core.Deprecated('Use phoneOrderCountResponseDescriptor instead')
const PhoneOrderCountResponse$json = {
  '1': 'PhoneOrderCountResponse',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `PhoneOrderCountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneOrderCountResponseDescriptor =
    $convert.base64Decode(
        'ChdQaG9uZU9yZGVyQ291bnRSZXNwb25zZRIUCgVjb3VudBgBIAEoBVIFY291bnQ=');

@$core.Deprecated('Use shutdownRequestDescriptor instead')
const ShutdownRequest$json = {
  '1': 'ShutdownRequest',
};

/// Descriptor for `ShutdownRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shutdownRequestDescriptor =
    $convert.base64Decode('Cg9TaHV0ZG93blJlcXVlc3Q=');

@$core.Deprecated('Use shutdownResponseDescriptor instead')
const ShutdownResponse$json = {
  '1': 'ShutdownResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ShutdownResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shutdownResponseDescriptor = $convert.base64Decode(
    'ChBTaHV0ZG93blJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');
