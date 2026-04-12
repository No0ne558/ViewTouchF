// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ViewTouchF';

  @override
  String get language => 'Language';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get restaurantSettings => 'Restaurant Settings';

  @override
  String get tapMenuToBegin => 'Tap a menu item to begin';

  @override
  String get phoneOrder => 'PHONE ORDER';

  @override
  String get checkout => 'Checkout';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get cannotConnectToDaemon => 'Cannot connect to POS daemon';

  @override
  String get retry => 'Retry';

  @override
  String get shutdownSystem => 'Shutdown System';

  @override
  String get refresh => 'Refresh';

  @override
  String get selectPrinter => 'Select printer';

  @override
  String get receiptPrinter => 'Receipt Printer';

  @override
  String get kitchenPrinter => 'Kitchen Printer';

  @override
  String get noCupsPrinters => 'No CUPS printers found on this system.';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get shutdown => 'Shutdown';

  @override
  String get pastOrders => 'Past Orders';

  @override
  String get phoneOrders => 'Phone Orders';

  @override
  String get admin => 'Admin';

  @override
  String get ticketLabel => 'Ticket:';

  @override
  String get cash => 'CASH';

  @override
  String get card => 'CARD';

  @override
  String get exact => 'Exact';

  @override
  String get clear => 'Clear';

  @override
  String get undoLastPayment => 'Undo last payment';

  @override
  String phoneOrderCreatedForName(Object name) {
    return 'Phone order created for $name';
  }

  @override
  String get phoneOrderCreated => 'Phone order created';

  @override
  String get phoneOrderLoadedForEditing => 'Phone order loaded for editing';

  @override
  String get phoneOrderTitle => 'Phone Order';

  @override
  String get nameLabel => 'Name';

  @override
  String get customerLabel => 'Customer';

  @override
  String get todaysOrders => 'Today\'s Orders';

  @override
  String get reprint => 'Reprint';

  @override
  String get phoneOrderLoaded => 'Phone order loaded';

  @override
  String get addCreditCardFee => 'Add Credit Card Fee';

  @override
  String get noOrdersFound => 'No orders found';

  @override
  String get addToOrder => 'Add to Order';

  @override
  String get updateItem => 'Update Item';

  @override
  String get specialInstructions => 'Special Instructions';

  @override
  String get instructionsChecked => 'Instructions ✓';

  @override
  String get defaultLabel => 'Default';

  @override
  String get included => 'Included';

  @override
  String get modNo => 'NO';

  @override
  String get modAdd => 'ADD';

  @override
  String get modExtra => 'EXTRA';

  @override
  String get modLight => 'LIGHT';

  @override
  String get modSide => 'SIDE';

  @override
  String get modDouble => 'DBL';

  @override
  String get total => 'Total';

  @override
  String get ccFee => 'CC Fee';

  @override
  String get newTotal => 'New Total';

  @override
  String get remaining => 'Remaining';

  @override
  String errorOccurred(Object error) {
    return 'Error: $error';
  }

  @override
  String get changeDueLabel => 'Change due:';

  @override
  String get voidLabel => 'VOID';

  @override
  String get comp => 'COMP';

  @override
  String get refund => 'REFUND';

  @override
  String get printError => 'Print error';

  @override
  String get kitchenPrintError => 'Kitchen print error';

  @override
  String receiptReprinted(Object jobId) {
    return 'Receipt reprinted (Job #$jobId)';
  }

  @override
  String get changeLabel => 'Change';

  @override
  String paymentLabel(Object type) {
    return '$type payment';
  }

  @override
  String get addItemFailed => 'Failed to add item';

  @override
  String get increaseItemFailed => 'Failed to increase item';

  @override
  String get updateItemFailed => 'Failed to update item';

  @override
  String get decreaseItemFailed => 'Failed to decrease item';

  @override
  String get removeItemFailed => 'Failed to remove item';

  @override
  String get setQuantityFailed => 'Failed to set quantity';

  @override
  String get loadPhoneOrderFailed => 'Failed to load phone order';

  @override
  String get checkoutFailed => 'Checkout failed';

  @override
  String operationFailed(Object action) {
    return '$action failed';
  }
}
