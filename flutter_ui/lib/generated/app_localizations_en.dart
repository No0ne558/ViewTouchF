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

  @override
  String get noActiveTicket => 'No active ticket';

  @override
  String get enterQuantity => 'Enter Quantity';

  @override
  String get removeItemTitle => 'Remove Item';

  @override
  String removeItemConfirm(Object name, Object qty) {
    return 'Remove $name (qty $qty) from the order?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get tax => 'Tax';

  @override
  String get enterText => 'Enter Text';

  @override
  String get spaceLabel => 'SPACE';

  @override
  String get menuItems => 'Menu Items';

  @override
  String get addItem => 'Add Item';

  @override
  String get noMenuItems => 'No menu items. Add one above.';

  @override
  String get deleteMenuItemTitle => 'Delete Menu Item';

  @override
  String deleteMenuItemConfirm(Object name) {
    return 'Remove \"$name\" from the menu?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get itemAdded => 'Item added';

  @override
  String get itemUpdated => 'Item updated';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String get editMenuItem => 'Edit Menu Item';

  @override
  String get newMenuItem => 'New Menu Item';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get itemDetails => 'Item Details';

  @override
  String get itemIdLabel => 'Item ID';

  @override
  String get itemNameLabel => 'Item Name';

  @override
  String get priceLabel => 'Price (\$)';

  @override
  String get categoryLabel => 'Category';

  @override
  String get sendToKitchen => 'Send to Kitchen';

  @override
  String get sendToKitchenSubtitle => 'Print this item on kitchen tickets';

  @override
  String get modifierGroups => 'Modifier Groups';

  @override
  String get addGroup => 'Add Group';

  @override
  String get noModifierGroups =>
      'No modifier groups. Items will be added as-is.';

  @override
  String get groupIdLabel => 'Group ID';

  @override
  String get groupNameLabel => 'Group Name';

  @override
  String get minSelectLabel => 'Min Select';

  @override
  String get maxSelectLabel => 'Max Select';

  @override
  String get removeGroup => 'Remove group';

  @override
  String get noModifiersInGroup => 'No modifiers in this group.';

  @override
  String get addModifier => 'Add Modifier';

  @override
  String get modifierIdLabel => 'Modifier ID';

  @override
  String get modifierNameLabel => 'Modifier Name';

  @override
  String get modifierPriceLabel => 'Modifier Price';

  @override
  String get priceShort => 'Price';

  @override
  String get loadMenuFailed => 'Failed to load menu';

  @override
  String get reasonOptional => 'Reason (optional)';

  @override
  String get all => 'All';

  @override
  String get closed => 'Closed';

  @override
  String get voided => 'Voided';

  @override
  String get comped => 'Comped';

  @override
  String get refunded => 'Refunded';

  @override
  String get commentLabel => 'Comment';

  @override
  String get noteLabel => 'Note:';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get editOrder => 'Edit Order';

  @override
  String get selectReportDate => 'Select Report Date';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get custom => 'Custom';

  @override
  String get printLabel => 'Print';

  @override
  String get noData => 'No data';

  @override
  String reportForDate(Object date) {
    return 'Report — $date';
  }

  @override
  String get dailyBreakdown => 'Daily Breakdown';

  @override
  String get tickets => 'tickets';

  @override
  String get grossRevenue => 'Gross Revenue';

  @override
  String get netRevenue => 'Net Revenue';

  @override
  String get totalCollected => 'Total Collected';
}
