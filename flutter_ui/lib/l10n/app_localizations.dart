import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ViewTouchF'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @restaurantSettings.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Settings'**
  String get restaurantSettings;

  /// No description provided for @tapMenuToBegin.
  ///
  /// In en, this message translates to:
  /// **'Tap a menu item to begin'**
  String get tapMenuToBegin;

  /// No description provided for @phoneOrder.
  ///
  /// In en, this message translates to:
  /// **'PHONE ORDER'**
  String get phoneOrder;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cannotConnectToDaemon.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to POS daemon'**
  String get cannotConnectToDaemon;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @shutdownSystem.
  ///
  /// In en, this message translates to:
  /// **'Shutdown System'**
  String get shutdownSystem;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @selectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Select printer'**
  String get selectPrinter;

  /// No description provided for @receiptPrinter.
  ///
  /// In en, this message translates to:
  /// **'Receipt Printer'**
  String get receiptPrinter;

  /// No description provided for @kitchenPrinter.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Printer'**
  String get kitchenPrinter;

  /// No description provided for @noCupsPrinters.
  ///
  /// In en, this message translates to:
  /// **'No CUPS printers found on this system.'**
  String get noCupsPrinters;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @shutdown.
  ///
  /// In en, this message translates to:
  /// **'Shutdown'**
  String get shutdown;

  /// No description provided for @pastOrders.
  ///
  /// In en, this message translates to:
  /// **'Past Orders'**
  String get pastOrders;

  /// No description provided for @phoneOrders.
  ///
  /// In en, this message translates to:
  /// **'Phone Orders'**
  String get phoneOrders;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @ticketLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket:'**
  String get ticketLabel;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'CASH'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'CARD'**
  String get card;

  /// No description provided for @exact.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get exact;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @undoLastPayment.
  ///
  /// In en, this message translates to:
  /// **'Undo last payment'**
  String get undoLastPayment;

  /// No description provided for @phoneOrderCreatedForName.
  ///
  /// In en, this message translates to:
  /// **'Phone order created for {name}'**
  String phoneOrderCreatedForName(Object name);

  /// No description provided for @phoneOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Phone order created'**
  String get phoneOrderCreated;

  /// No description provided for @phoneOrderLoadedForEditing.
  ///
  /// In en, this message translates to:
  /// **'Phone order loaded for editing'**
  String get phoneOrderLoadedForEditing;

  /// No description provided for @phoneOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Order'**
  String get phoneOrderTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @todaysOrders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get todaysOrders;

  /// No description provided for @reprint.
  ///
  /// In en, this message translates to:
  /// **'Reprint'**
  String get reprint;

  /// No description provided for @phoneOrderLoaded.
  ///
  /// In en, this message translates to:
  /// **'Phone order loaded'**
  String get phoneOrderLoaded;

  /// No description provided for @addCreditCardFee.
  ///
  /// In en, this message translates to:
  /// **'Add Credit Card Fee'**
  String get addCreditCardFee;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @addToOrder.
  ///
  /// In en, this message translates to:
  /// **'Add to Order'**
  String get addToOrder;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Item'**
  String get updateItem;

  /// No description provided for @specialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get specialInstructions;

  /// No description provided for @instructionsChecked.
  ///
  /// In en, this message translates to:
  /// **'Instructions ✓'**
  String get instructionsChecked;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @included.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get included;

  /// No description provided for @modNo.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get modNo;

  /// No description provided for @modAdd.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get modAdd;

  /// No description provided for @modExtra.
  ///
  /// In en, this message translates to:
  /// **'EXTRA'**
  String get modExtra;

  /// No description provided for @modLight.
  ///
  /// In en, this message translates to:
  /// **'LIGHT'**
  String get modLight;

  /// No description provided for @modSide.
  ///
  /// In en, this message translates to:
  /// **'SIDE'**
  String get modSide;

  /// No description provided for @modDouble.
  ///
  /// In en, this message translates to:
  /// **'DBL'**
  String get modDouble;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @ccFee.
  ///
  /// In en, this message translates to:
  /// **'CC Fee'**
  String get ccFee;

  /// No description provided for @newTotal.
  ///
  /// In en, this message translates to:
  /// **'New Total'**
  String get newTotal;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @changeDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Change due:'**
  String get changeDueLabel;

  /// No description provided for @voidLabel.
  ///
  /// In en, this message translates to:
  /// **'VOID'**
  String get voidLabel;

  /// No description provided for @comp.
  ///
  /// In en, this message translates to:
  /// **'COMP'**
  String get comp;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'REFUND'**
  String get refund;

  /// No description provided for @printError.
  ///
  /// In en, this message translates to:
  /// **'Print error'**
  String get printError;

  /// No description provided for @kitchenPrintError.
  ///
  /// In en, this message translates to:
  /// **'Kitchen print error'**
  String get kitchenPrintError;

  /// No description provided for @receiptReprinted.
  ///
  /// In en, this message translates to:
  /// **'Receipt reprinted (Job #{jobId})'**
  String receiptReprinted(Object jobId);

  /// No description provided for @changeLabel.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeLabel;

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'{type} payment'**
  String paymentLabel(Object type);

  /// No description provided for @addItemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add item'**
  String get addItemFailed;

  /// No description provided for @increaseItemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to increase item'**
  String get increaseItemFailed;

  /// No description provided for @updateItemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update item'**
  String get updateItemFailed;

  /// No description provided for @decreaseItemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to decrease item'**
  String get decreaseItemFailed;

  /// No description provided for @removeItemFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove item'**
  String get removeItemFailed;

  /// No description provided for @setQuantityFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to set quantity'**
  String get setQuantityFailed;

  /// No description provided for @loadPhoneOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load phone order'**
  String get loadPhoneOrderFailed;

  /// No description provided for @checkoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Checkout failed'**
  String get checkoutFailed;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'{action} failed'**
  String operationFailed(Object action);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
