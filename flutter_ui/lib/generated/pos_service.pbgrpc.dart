// This is a generated file - do not edit.
//
// Generated from proto/pos_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'pos_service.pb.dart' as $0;

export 'pos_service.pb.dart';

@$pb.GrpcServiceName('vt_proto.PosService')
class PosServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PosServiceClient(super.channel, {super.options, super.interceptors});

  /// Register
  $grpc.ResponseFuture<$0.GetMenuResponse> getMenu(
    $0.GetMenuRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMenu, request, options: options);
  }

  $grpc.ResponseFuture<$0.NewTicketResponse> newTicket(
    $0.NewTicketRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$newTicket, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddItemResponse> addItem(
    $0.AddItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemoveItemResponse> removeItem(
    $0.RemoveItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateItemResponse> updateItem(
    $0.UpdateItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.DecreaseItemResponse> decreaseItem(
    $0.DecreaseItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$decreaseItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetTicketResponse> getTicket(
    $0.GetTicketRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTicket, request, options: options);
  }

  $grpc.ResponseFuture<$0.CheckoutResponse> checkout(
    $0.CheckoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkout, request, options: options);
  }

  $grpc.ResponseFuture<$0.PrintReceiptResponse> printReceipt(
    $0.PrintReceiptRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$printReceipt, request, options: options);
  }

  $grpc.ResponseStream<$0.PrintStatusEvent> watchPrintStatus(
    $0.PrintReceiptRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchPrintStatus, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Ticket history & actions
  $grpc.ResponseFuture<$0.ListTicketsResponse> listTickets(
    $0.ListTicketsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTickets, request, options: options);
  }

  $grpc.ResponseFuture<$0.TicketActionResponse> ticketAction(
    $0.TicketActionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$ticketAction, request, options: options);
  }

  /// Admin — settings
  $grpc.ResponseFuture<$0.GetSettingsResponse> getSettings(
    $0.GetSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateSettingsResponse> updateSettings(
    $0.UpdateSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateSettings, request, options: options);
  }

  /// Printer discovery & kitchen printing
  $grpc.ResponseFuture<$0.ListPrintersResponse> listPrinters(
    $0.ListPrintersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPrinters, request, options: options);
  }

  $grpc.ResponseFuture<$0.PrintKitchenResponse> printKitchen(
    $0.PrintKitchenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$printKitchen, request, options: options);
  }

  /// Admin — menu CRUD
  $grpc.ResponseFuture<$0.AddMenuItemResponse> addMenuItem(
    $0.AddMenuItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addMenuItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateMenuItemResponse> updateMenuItem(
    $0.UpdateMenuItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateMenuItem, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteMenuItemResponse> deleteMenuItem(
    $0.DeleteMenuItemRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteMenuItem, request, options: options);
  }

  /// Reporting
  $grpc.ResponseFuture<$0.DailyReportResponse> getDailyReport(
    $0.DailyReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDailyReport, request, options: options);
  }

  $grpc.ResponseFuture<$0.ReportHistoryResponse> getReportHistory(
    $0.ReportHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getReportHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.DateRangeReportResponse> getDateRangeReport(
    $0.DateRangeReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDateRangeReport, request, options: options);
  }

  $grpc.ResponseFuture<$0.PrintReportResponse> printReport(
    $0.PrintReportRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$printReport, request, options: options);
  }

  /// End of day
  $grpc.ResponseFuture<$0.EndDayResponse> endDay(
    $0.EndDayRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$endDay, request, options: options);
  }

  /// Phone orders
  $grpc.ResponseFuture<$0.CreatePhoneOrderResponse> createPhoneOrder(
    $0.CreatePhoneOrderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPhoneOrder, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPhoneOrdersResponse> listPhoneOrders(
    $0.ListPhoneOrdersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPhoneOrders, request, options: options);
  }

  $grpc.ResponseFuture<$0.PhoneOrderActionResponse> phoneOrderAction(
    $0.PhoneOrderActionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$phoneOrderAction, request, options: options);
  }

  $grpc.ResponseFuture<$0.PhoneOrderCountResponse> getPhoneOrderCount(
    $0.PhoneOrderCountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPhoneOrderCount, request, options: options);
  }

  /// System
  $grpc.ResponseFuture<$0.ShutdownResponse> shutdown(
    $0.ShutdownRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$shutdown, request, options: options);
  }

  // method descriptors

  static final _$getMenu =
      $grpc.ClientMethod<$0.GetMenuRequest, $0.GetMenuResponse>(
          '/vt_proto.PosService/GetMenu',
          ($0.GetMenuRequest value) => value.writeToBuffer(),
          $0.GetMenuResponse.fromBuffer);
  static final _$newTicket =
      $grpc.ClientMethod<$0.NewTicketRequest, $0.NewTicketResponse>(
          '/vt_proto.PosService/NewTicket',
          ($0.NewTicketRequest value) => value.writeToBuffer(),
          $0.NewTicketResponse.fromBuffer);
  static final _$addItem =
      $grpc.ClientMethod<$0.AddItemRequest, $0.AddItemResponse>(
          '/vt_proto.PosService/AddItem',
          ($0.AddItemRequest value) => value.writeToBuffer(),
          $0.AddItemResponse.fromBuffer);
  static final _$removeItem =
      $grpc.ClientMethod<$0.RemoveItemRequest, $0.RemoveItemResponse>(
          '/vt_proto.PosService/RemoveItem',
          ($0.RemoveItemRequest value) => value.writeToBuffer(),
          $0.RemoveItemResponse.fromBuffer);
  static final _$updateItem =
      $grpc.ClientMethod<$0.UpdateItemRequest, $0.UpdateItemResponse>(
          '/vt_proto.PosService/UpdateItem',
          ($0.UpdateItemRequest value) => value.writeToBuffer(),
          $0.UpdateItemResponse.fromBuffer);
  static final _$decreaseItem =
      $grpc.ClientMethod<$0.DecreaseItemRequest, $0.DecreaseItemResponse>(
          '/vt_proto.PosService/DecreaseItem',
          ($0.DecreaseItemRequest value) => value.writeToBuffer(),
          $0.DecreaseItemResponse.fromBuffer);
  static final _$getTicket =
      $grpc.ClientMethod<$0.GetTicketRequest, $0.GetTicketResponse>(
          '/vt_proto.PosService/GetTicket',
          ($0.GetTicketRequest value) => value.writeToBuffer(),
          $0.GetTicketResponse.fromBuffer);
  static final _$checkout =
      $grpc.ClientMethod<$0.CheckoutRequest, $0.CheckoutResponse>(
          '/vt_proto.PosService/Checkout',
          ($0.CheckoutRequest value) => value.writeToBuffer(),
          $0.CheckoutResponse.fromBuffer);
  static final _$printReceipt =
      $grpc.ClientMethod<$0.PrintReceiptRequest, $0.PrintReceiptResponse>(
          '/vt_proto.PosService/PrintReceipt',
          ($0.PrintReceiptRequest value) => value.writeToBuffer(),
          $0.PrintReceiptResponse.fromBuffer);
  static final _$watchPrintStatus =
      $grpc.ClientMethod<$0.PrintReceiptRequest, $0.PrintStatusEvent>(
          '/vt_proto.PosService/WatchPrintStatus',
          ($0.PrintReceiptRequest value) => value.writeToBuffer(),
          $0.PrintStatusEvent.fromBuffer);
  static final _$listTickets =
      $grpc.ClientMethod<$0.ListTicketsRequest, $0.ListTicketsResponse>(
          '/vt_proto.PosService/ListTickets',
          ($0.ListTicketsRequest value) => value.writeToBuffer(),
          $0.ListTicketsResponse.fromBuffer);
  static final _$ticketAction =
      $grpc.ClientMethod<$0.TicketActionRequest, $0.TicketActionResponse>(
          '/vt_proto.PosService/TicketAction',
          ($0.TicketActionRequest value) => value.writeToBuffer(),
          $0.TicketActionResponse.fromBuffer);
  static final _$getSettings =
      $grpc.ClientMethod<$0.GetSettingsRequest, $0.GetSettingsResponse>(
          '/vt_proto.PosService/GetSettings',
          ($0.GetSettingsRequest value) => value.writeToBuffer(),
          $0.GetSettingsResponse.fromBuffer);
  static final _$updateSettings =
      $grpc.ClientMethod<$0.UpdateSettingsRequest, $0.UpdateSettingsResponse>(
          '/vt_proto.PosService/UpdateSettings',
          ($0.UpdateSettingsRequest value) => value.writeToBuffer(),
          $0.UpdateSettingsResponse.fromBuffer);
  static final _$listPrinters =
      $grpc.ClientMethod<$0.ListPrintersRequest, $0.ListPrintersResponse>(
          '/vt_proto.PosService/ListPrinters',
          ($0.ListPrintersRequest value) => value.writeToBuffer(),
          $0.ListPrintersResponse.fromBuffer);
  static final _$printKitchen =
      $grpc.ClientMethod<$0.PrintKitchenRequest, $0.PrintKitchenResponse>(
          '/vt_proto.PosService/PrintKitchen',
          ($0.PrintKitchenRequest value) => value.writeToBuffer(),
          $0.PrintKitchenResponse.fromBuffer);
  static final _$addMenuItem =
      $grpc.ClientMethod<$0.AddMenuItemRequest, $0.AddMenuItemResponse>(
          '/vt_proto.PosService/AddMenuItem',
          ($0.AddMenuItemRequest value) => value.writeToBuffer(),
          $0.AddMenuItemResponse.fromBuffer);
  static final _$updateMenuItem =
      $grpc.ClientMethod<$0.UpdateMenuItemRequest, $0.UpdateMenuItemResponse>(
          '/vt_proto.PosService/UpdateMenuItem',
          ($0.UpdateMenuItemRequest value) => value.writeToBuffer(),
          $0.UpdateMenuItemResponse.fromBuffer);
  static final _$deleteMenuItem =
      $grpc.ClientMethod<$0.DeleteMenuItemRequest, $0.DeleteMenuItemResponse>(
          '/vt_proto.PosService/DeleteMenuItem',
          ($0.DeleteMenuItemRequest value) => value.writeToBuffer(),
          $0.DeleteMenuItemResponse.fromBuffer);
  static final _$getDailyReport =
      $grpc.ClientMethod<$0.DailyReportRequest, $0.DailyReportResponse>(
          '/vt_proto.PosService/GetDailyReport',
          ($0.DailyReportRequest value) => value.writeToBuffer(),
          $0.DailyReportResponse.fromBuffer);
  static final _$getReportHistory =
      $grpc.ClientMethod<$0.ReportHistoryRequest, $0.ReportHistoryResponse>(
          '/vt_proto.PosService/GetReportHistory',
          ($0.ReportHistoryRequest value) => value.writeToBuffer(),
          $0.ReportHistoryResponse.fromBuffer);
  static final _$getDateRangeReport =
      $grpc.ClientMethod<$0.DateRangeReportRequest, $0.DateRangeReportResponse>(
          '/vt_proto.PosService/GetDateRangeReport',
          ($0.DateRangeReportRequest value) => value.writeToBuffer(),
          $0.DateRangeReportResponse.fromBuffer);
  static final _$printReport =
      $grpc.ClientMethod<$0.PrintReportRequest, $0.PrintReportResponse>(
          '/vt_proto.PosService/PrintReport',
          ($0.PrintReportRequest value) => value.writeToBuffer(),
          $0.PrintReportResponse.fromBuffer);
  static final _$endDay =
      $grpc.ClientMethod<$0.EndDayRequest, $0.EndDayResponse>(
          '/vt_proto.PosService/EndDay',
          ($0.EndDayRequest value) => value.writeToBuffer(),
          $0.EndDayResponse.fromBuffer);
  static final _$createPhoneOrder = $grpc.ClientMethod<
          $0.CreatePhoneOrderRequest, $0.CreatePhoneOrderResponse>(
      '/vt_proto.PosService/CreatePhoneOrder',
      ($0.CreatePhoneOrderRequest value) => value.writeToBuffer(),
      $0.CreatePhoneOrderResponse.fromBuffer);
  static final _$listPhoneOrders =
      $grpc.ClientMethod<$0.ListPhoneOrdersRequest, $0.ListPhoneOrdersResponse>(
          '/vt_proto.PosService/ListPhoneOrders',
          ($0.ListPhoneOrdersRequest value) => value.writeToBuffer(),
          $0.ListPhoneOrdersResponse.fromBuffer);
  static final _$phoneOrderAction = $grpc.ClientMethod<
          $0.PhoneOrderActionRequest, $0.PhoneOrderActionResponse>(
      '/vt_proto.PosService/PhoneOrderAction',
      ($0.PhoneOrderActionRequest value) => value.writeToBuffer(),
      $0.PhoneOrderActionResponse.fromBuffer);
  static final _$getPhoneOrderCount =
      $grpc.ClientMethod<$0.PhoneOrderCountRequest, $0.PhoneOrderCountResponse>(
          '/vt_proto.PosService/GetPhoneOrderCount',
          ($0.PhoneOrderCountRequest value) => value.writeToBuffer(),
          $0.PhoneOrderCountResponse.fromBuffer);
  static final _$shutdown =
      $grpc.ClientMethod<$0.ShutdownRequest, $0.ShutdownResponse>(
          '/vt_proto.PosService/Shutdown',
          ($0.ShutdownRequest value) => value.writeToBuffer(),
          $0.ShutdownResponse.fromBuffer);
}

@$pb.GrpcServiceName('vt_proto.PosService')
abstract class PosServiceBase extends $grpc.Service {
  $core.String get $name => 'vt_proto.PosService';

  PosServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetMenuRequest, $0.GetMenuResponse>(
        'GetMenu',
        getMenu_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMenuRequest.fromBuffer(value),
        ($0.GetMenuResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NewTicketRequest, $0.NewTicketResponse>(
        'NewTicket',
        newTicket_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NewTicketRequest.fromBuffer(value),
        ($0.NewTicketResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddItemRequest, $0.AddItemResponse>(
        'AddItem',
        addItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddItemRequest.fromBuffer(value),
        ($0.AddItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveItemRequest, $0.RemoveItemResponse>(
        'RemoveItem',
        removeItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemoveItemRequest.fromBuffer(value),
        ($0.RemoveItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateItemRequest, $0.UpdateItemResponse>(
        'UpdateItem',
        updateItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateItemRequest.fromBuffer(value),
        ($0.UpdateItemResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DecreaseItemRequest, $0.DecreaseItemResponse>(
            'DecreaseItem',
            decreaseItem_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DecreaseItemRequest.fromBuffer(value),
            ($0.DecreaseItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTicketRequest, $0.GetTicketResponse>(
        'GetTicket',
        getTicket_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetTicketRequest.fromBuffer(value),
        ($0.GetTicketResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CheckoutRequest, $0.CheckoutResponse>(
        'Checkout',
        checkout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CheckoutRequest.fromBuffer(value),
        ($0.CheckoutResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PrintReceiptRequest, $0.PrintReceiptResponse>(
            'PrintReceipt',
            printReceipt_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PrintReceiptRequest.fromBuffer(value),
            ($0.PrintReceiptResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PrintReceiptRequest, $0.PrintStatusEvent>(
        'WatchPrintStatus',
        watchPrintStatus_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.PrintReceiptRequest.fromBuffer(value),
        ($0.PrintStatusEvent value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListTicketsRequest, $0.ListTicketsResponse>(
            'ListTickets',
            listTickets_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListTicketsRequest.fromBuffer(value),
            ($0.ListTicketsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.TicketActionRequest, $0.TicketActionResponse>(
            'TicketAction',
            ticketAction_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.TicketActionRequest.fromBuffer(value),
            ($0.TicketActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetSettingsRequest, $0.GetSettingsResponse>(
            'GetSettings',
            getSettings_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSettingsRequest.fromBuffer(value),
            ($0.GetSettingsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateSettingsRequest,
            $0.UpdateSettingsResponse>(
        'UpdateSettings',
        updateSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateSettingsRequest.fromBuffer(value),
        ($0.UpdateSettingsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPrintersRequest, $0.ListPrintersResponse>(
            'ListPrinters',
            listPrinters_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPrintersRequest.fromBuffer(value),
            ($0.ListPrintersResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PrintKitchenRequest, $0.PrintKitchenResponse>(
            'PrintKitchen',
            printKitchen_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PrintKitchenRequest.fromBuffer(value),
            ($0.PrintKitchenResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddMenuItemRequest, $0.AddMenuItemResponse>(
            'AddMenuItem',
            addMenuItem_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddMenuItemRequest.fromBuffer(value),
            ($0.AddMenuItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateMenuItemRequest,
            $0.UpdateMenuItemResponse>(
        'UpdateMenuItem',
        updateMenuItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateMenuItemRequest.fromBuffer(value),
        ($0.UpdateMenuItemResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteMenuItemRequest,
            $0.DeleteMenuItemResponse>(
        'DeleteMenuItem',
        deleteMenuItem_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteMenuItemRequest.fromBuffer(value),
        ($0.DeleteMenuItemResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DailyReportRequest, $0.DailyReportResponse>(
            'GetDailyReport',
            getDailyReport_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DailyReportRequest.fromBuffer(value),
            ($0.DailyReportResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ReportHistoryRequest, $0.ReportHistoryResponse>(
            'GetReportHistory',
            getReportHistory_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ReportHistoryRequest.fromBuffer(value),
            ($0.ReportHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DateRangeReportRequest,
            $0.DateRangeReportResponse>(
        'GetDateRangeReport',
        getDateRangeReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DateRangeReportRequest.fromBuffer(value),
        ($0.DateRangeReportResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PrintReportRequest, $0.PrintReportResponse>(
            'PrintReport',
            printReport_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PrintReportRequest.fromBuffer(value),
            ($0.PrintReportResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EndDayRequest, $0.EndDayResponse>(
        'EndDay',
        endDay_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EndDayRequest.fromBuffer(value),
        ($0.EndDayResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreatePhoneOrderRequest,
            $0.CreatePhoneOrderResponse>(
        'CreatePhoneOrder',
        createPhoneOrder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreatePhoneOrderRequest.fromBuffer(value),
        ($0.CreatePhoneOrderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPhoneOrdersRequest,
            $0.ListPhoneOrdersResponse>(
        'ListPhoneOrders',
        listPhoneOrders_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListPhoneOrdersRequest.fromBuffer(value),
        ($0.ListPhoneOrdersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PhoneOrderActionRequest,
            $0.PhoneOrderActionResponse>(
        'PhoneOrderAction',
        phoneOrderAction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PhoneOrderActionRequest.fromBuffer(value),
        ($0.PhoneOrderActionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PhoneOrderCountRequest,
            $0.PhoneOrderCountResponse>(
        'GetPhoneOrderCount',
        getPhoneOrderCount_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PhoneOrderCountRequest.fromBuffer(value),
        ($0.PhoneOrderCountResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ShutdownRequest, $0.ShutdownResponse>(
        'Shutdown',
        shutdown_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ShutdownRequest.fromBuffer(value),
        ($0.ShutdownResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetMenuResponse> getMenu_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMenuRequest> $request) async {
    return getMenu($call, await $request);
  }

  $async.Future<$0.GetMenuResponse> getMenu(
      $grpc.ServiceCall call, $0.GetMenuRequest request);

  $async.Future<$0.NewTicketResponse> newTicket_Pre($grpc.ServiceCall $call,
      $async.Future<$0.NewTicketRequest> $request) async {
    return newTicket($call, await $request);
  }

  $async.Future<$0.NewTicketResponse> newTicket(
      $grpc.ServiceCall call, $0.NewTicketRequest request);

  $async.Future<$0.AddItemResponse> addItem_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddItemRequest> $request) async {
    return addItem($call, await $request);
  }

  $async.Future<$0.AddItemResponse> addItem(
      $grpc.ServiceCall call, $0.AddItemRequest request);

  $async.Future<$0.RemoveItemResponse> removeItem_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveItemRequest> $request) async {
    return removeItem($call, await $request);
  }

  $async.Future<$0.RemoveItemResponse> removeItem(
      $grpc.ServiceCall call, $0.RemoveItemRequest request);

  $async.Future<$0.UpdateItemResponse> updateItem_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateItemRequest> $request) async {
    return updateItem($call, await $request);
  }

  $async.Future<$0.UpdateItemResponse> updateItem(
      $grpc.ServiceCall call, $0.UpdateItemRequest request);

  $async.Future<$0.DecreaseItemResponse> decreaseItem_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DecreaseItemRequest> $request) async {
    return decreaseItem($call, await $request);
  }

  $async.Future<$0.DecreaseItemResponse> decreaseItem(
      $grpc.ServiceCall call, $0.DecreaseItemRequest request);

  $async.Future<$0.GetTicketResponse> getTicket_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetTicketRequest> $request) async {
    return getTicket($call, await $request);
  }

  $async.Future<$0.GetTicketResponse> getTicket(
      $grpc.ServiceCall call, $0.GetTicketRequest request);

  $async.Future<$0.CheckoutResponse> checkout_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CheckoutRequest> $request) async {
    return checkout($call, await $request);
  }

  $async.Future<$0.CheckoutResponse> checkout(
      $grpc.ServiceCall call, $0.CheckoutRequest request);

  $async.Future<$0.PrintReceiptResponse> printReceipt_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PrintReceiptRequest> $request) async {
    return printReceipt($call, await $request);
  }

  $async.Future<$0.PrintReceiptResponse> printReceipt(
      $grpc.ServiceCall call, $0.PrintReceiptRequest request);

  $async.Stream<$0.PrintStatusEvent> watchPrintStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PrintReceiptRequest> $request) async* {
    yield* watchPrintStatus($call, await $request);
  }

  $async.Stream<$0.PrintStatusEvent> watchPrintStatus(
      $grpc.ServiceCall call, $0.PrintReceiptRequest request);

  $async.Future<$0.ListTicketsResponse> listTickets_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListTicketsRequest> $request) async {
    return listTickets($call, await $request);
  }

  $async.Future<$0.ListTicketsResponse> listTickets(
      $grpc.ServiceCall call, $0.ListTicketsRequest request);

  $async.Future<$0.TicketActionResponse> ticketAction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TicketActionRequest> $request) async {
    return ticketAction($call, await $request);
  }

  $async.Future<$0.TicketActionResponse> ticketAction(
      $grpc.ServiceCall call, $0.TicketActionRequest request);

  $async.Future<$0.GetSettingsResponse> getSettings_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSettingsRequest> $request) async {
    return getSettings($call, await $request);
  }

  $async.Future<$0.GetSettingsResponse> getSettings(
      $grpc.ServiceCall call, $0.GetSettingsRequest request);

  $async.Future<$0.UpdateSettingsResponse> updateSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateSettingsRequest> $request) async {
    return updateSettings($call, await $request);
  }

  $async.Future<$0.UpdateSettingsResponse> updateSettings(
      $grpc.ServiceCall call, $0.UpdateSettingsRequest request);

  $async.Future<$0.ListPrintersResponse> listPrinters_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPrintersRequest> $request) async {
    return listPrinters($call, await $request);
  }

  $async.Future<$0.ListPrintersResponse> listPrinters(
      $grpc.ServiceCall call, $0.ListPrintersRequest request);

  $async.Future<$0.PrintKitchenResponse> printKitchen_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PrintKitchenRequest> $request) async {
    return printKitchen($call, await $request);
  }

  $async.Future<$0.PrintKitchenResponse> printKitchen(
      $grpc.ServiceCall call, $0.PrintKitchenRequest request);

  $async.Future<$0.AddMenuItemResponse> addMenuItem_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddMenuItemRequest> $request) async {
    return addMenuItem($call, await $request);
  }

  $async.Future<$0.AddMenuItemResponse> addMenuItem(
      $grpc.ServiceCall call, $0.AddMenuItemRequest request);

  $async.Future<$0.UpdateMenuItemResponse> updateMenuItem_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateMenuItemRequest> $request) async {
    return updateMenuItem($call, await $request);
  }

  $async.Future<$0.UpdateMenuItemResponse> updateMenuItem(
      $grpc.ServiceCall call, $0.UpdateMenuItemRequest request);

  $async.Future<$0.DeleteMenuItemResponse> deleteMenuItem_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteMenuItemRequest> $request) async {
    return deleteMenuItem($call, await $request);
  }

  $async.Future<$0.DeleteMenuItemResponse> deleteMenuItem(
      $grpc.ServiceCall call, $0.DeleteMenuItemRequest request);

  $async.Future<$0.DailyReportResponse> getDailyReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DailyReportRequest> $request) async {
    return getDailyReport($call, await $request);
  }

  $async.Future<$0.DailyReportResponse> getDailyReport(
      $grpc.ServiceCall call, $0.DailyReportRequest request);

  $async.Future<$0.ReportHistoryResponse> getReportHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ReportHistoryRequest> $request) async {
    return getReportHistory($call, await $request);
  }

  $async.Future<$0.ReportHistoryResponse> getReportHistory(
      $grpc.ServiceCall call, $0.ReportHistoryRequest request);

  $async.Future<$0.DateRangeReportResponse> getDateRangeReport_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DateRangeReportRequest> $request) async {
    return getDateRangeReport($call, await $request);
  }

  $async.Future<$0.DateRangeReportResponse> getDateRangeReport(
      $grpc.ServiceCall call, $0.DateRangeReportRequest request);

  $async.Future<$0.PrintReportResponse> printReport_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PrintReportRequest> $request) async {
    return printReport($call, await $request);
  }

  $async.Future<$0.PrintReportResponse> printReport(
      $grpc.ServiceCall call, $0.PrintReportRequest request);

  $async.Future<$0.EndDayResponse> endDay_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EndDayRequest> $request) async {
    return endDay($call, await $request);
  }

  $async.Future<$0.EndDayResponse> endDay(
      $grpc.ServiceCall call, $0.EndDayRequest request);

  $async.Future<$0.CreatePhoneOrderResponse> createPhoneOrder_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreatePhoneOrderRequest> $request) async {
    return createPhoneOrder($call, await $request);
  }

  $async.Future<$0.CreatePhoneOrderResponse> createPhoneOrder(
      $grpc.ServiceCall call, $0.CreatePhoneOrderRequest request);

  $async.Future<$0.ListPhoneOrdersResponse> listPhoneOrders_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPhoneOrdersRequest> $request) async {
    return listPhoneOrders($call, await $request);
  }

  $async.Future<$0.ListPhoneOrdersResponse> listPhoneOrders(
      $grpc.ServiceCall call, $0.ListPhoneOrdersRequest request);

  $async.Future<$0.PhoneOrderActionResponse> phoneOrderAction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PhoneOrderActionRequest> $request) async {
    return phoneOrderAction($call, await $request);
  }

  $async.Future<$0.PhoneOrderActionResponse> phoneOrderAction(
      $grpc.ServiceCall call, $0.PhoneOrderActionRequest request);

  $async.Future<$0.PhoneOrderCountResponse> getPhoneOrderCount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PhoneOrderCountRequest> $request) async {
    return getPhoneOrderCount($call, await $request);
  }

  $async.Future<$0.PhoneOrderCountResponse> getPhoneOrderCount(
      $grpc.ServiceCall call, $0.PhoneOrderCountRequest request);

  $async.Future<$0.ShutdownResponse> shutdown_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ShutdownRequest> $request) async {
    return shutdown($call, await $request);
  }

  $async.Future<$0.ShutdownResponse> shutdown(
      $grpc.ServiceCall call, $0.ShutdownRequest request);
}
