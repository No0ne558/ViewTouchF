# Changelog

All notable changes to **ViewTouchF** (ViewTouch Food Truck) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] — 2026-04-03

### Added
- **X Report**: monthly report accessible from End Day tab — select any year and month from a calendar grid, prints full-month summary with daily breakdown to receipt printer
- **ESC/POS formatted reports**: all printed reports (Z-Report, Daily, Weekly, Monthly, Yearly, Custom, X-Report) now use proper thermal receipt formatting — bold section headers, aligned columns, item sales table, daily breakdown table, and print timestamp
- Year selector with left/right arrows and dropdown in the X Report month picker (2020–present)

### Fixed
- Weekly, Monthly, and Yearly report printing now correctly sends date ranges to the backend (was sending empty start/end dates)

## [2.1.0] — 2026-04-03

### Added
- Reusable `TouchscreenKeyboard` widget, `TouchKeyboardDialog`, and `TouchTextField` drop-in replacement for on-screen QWERTY input everywhere
- On-screen keyboard for VOID/COMP/REFUND reason dialogs, admin settings fields, and admin menu editor fields
- Customer name and comment printed on receipt tickets (bold "Customer:" and "Note:" lines)
- Customer name and comment printed on kitchen tickets
- Kitchen ticket automatically sent when a phone order is created

### Fixed
- Phone order badge count stuck at 1 after the last phone order is checked out — badge now refreshes correctly to 0
- Duplicate receipt printing when checking out a phone order — receipt/kitchen prints are now skipped since they were already printed at phone order creation

## [2.0.0] — 2026-04-03

### Added

#### Architecture & Core
- Full-stack POS system with C++17 backend daemon (`vt_daemon`) and Flutter Linux frontend
- gRPC service contract (`pos_service.proto`) over Unix domain socket (`/tmp/viewtouch/pos.sock`)
- CMake build system with automatic protobuf/gRPC C++ code generation
- **UI scaling**: base design resolution of 1920×1080 with automatic proportional scale-up on higher-resolution displays via `FittedBox` in `MaterialApp.builder`
- GTK window default size set to 1920×1080; fullscreen kiosk mode
- `mounted` guards on all async `setState` calls to prevent crashes during widget rebuilds
- `build.sh` one-command build script (daemon, proto-dart, flutter, or all)
- systemd service unit (`vt-daemon.service`) for production deployment

#### Menu System
- Menu item CRUD (add, update, delete) with name, price, and category
- Modifier groups with configurable `min_select` / `max_select`
- Per-modifier defaults (`is_default`) and individual pricing
- Modifier actions: **NO**, **ADD**, **EXTRA**, **LIGHT**, **SIDE**, **DOUBLE**
- Modifier dialog enlarged (700px wide) with bigger action chips, larger text, and 48px touch-friendly buttons for touchscreen use
- `send_to_kitchen` flag per menu item for kitchen ticket routing

#### Ticket & Order Management
- Ticket creation with auto-generated IDs
- Add items with quantity tracking and modifier support
- Swipe-right to increase quantity (+1)
- Swipe-left to decrease quantity (−1)
- Line-key based item deduplication (same item + same modifiers = same line)
- Ticket statuses: `OPEN`, `CLOSED`, `VOIDED`, `COMPED`, `REFUNDED`
- **Phone orders**: place current ticket on hold for phone-in customers with name and comment
- Phone order QWERTY keyboard dialog (letters, numbers, symbols) for touchscreen text entry
- Phone order hold list with Checkout and Cancel Order actions per order
- Phone icon in app bar with orange badge counter showing pending phone orders
- Automatic receipt printing when a phone order is created (includes customer name/comment)
- Phone Order button in ticket panel beside Checkout (orange themed)

#### Checkout & Payments
- Checkout dialog with on-screen numeric keypad — enlarged for touchscreen (540×820, larger keypad buttons, bigger CASH/CARD pay buttons)
- Split payment support — combine CASH and CARD in any number of legs
- Exact-amount and clear quick buttons (48px height for easy tapping)
- Partial payment tracking with undo (remove last payment leg)
- Automatic change-due calculation for overpayment

#### Past Orders
- Past orders dialog accessible from register screen (history icon)
- Filter by status: All, Closed, Voided, Comped, Refunded
- Expandable ticket detail showing items, modifiers, and payment breakdown
- Reprint any ticket to the receipt printer
- VOID / COMP / REFUND actions with optional reason prompt

#### Reporting
- Daily report with per-item sales breakdown
- Reporting periods: Daily, Weekly, Monthly, Yearly, Custom date range
- Date picker for single-day reports; date-range picker for custom periods
- Summary metrics: net revenue, gross revenue, tax collected, cash total, card total, ticket count, voided/comped/refunded counts and totals
- `GetDateRangeReport` RPC returning aggregate summary + daily breakdown
- Print any report to the receipt printer via `PrintReport` RPC

#### End of Day
- End Day admin tab with confirmation dialog
- Z-Report generation aggregating the full day's activity
- Automatic Z-Report printing to receipt printer
- Clears closed ticket history while preserving archived reports for future viewing

#### Printing
- CUPS integration for ESC/POS thermal receipt printers
- Dual printer support: separate receipt and kitchen printers
- CUPS printer discovery (`ListPrinters` RPC) in admin settings
- Receipt format: header, items with modifiers indented, subtotal/tax/total, payment info, footer
- Kitchen ticket format: items with modifiers only (no pricing)
- Report printing (plain text through ESC/POS init + feed + cut)

#### Flutter UI
- Fullscreen kiosk-mode via GTK `gtk_window_fullscreen()`
- Register screen: 65/35 split — menu grid (left) and ticket panel (right)
- Menu grid with category-colored cards
- Ticket panel with item list, modifier badges, subtotal/tax/total
- Modifier selection dialog: radio buttons (single-select), action chips (multi-select)
- Admin panel with 4 tabs: Settings, Menu, Reports, End Day
- Admin settings: restaurant name, tax rate (basis points), receipt/kitchen printer config
- Admin menu editor: full-page item editor with modifier group management
- Admin reports: segmented period selector, summary cards, item sales table, daily breakdown sidebar, print button

#### Infrastructure
- `.gitignore` for C++ build artifacts, Flutter build/ephemeral, IDE files
- `RobotoMono` font bundled for monospaced keypad display

[2.2.0]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.2.0
[2.1.0]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.1.0
[2.0.0]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.0.0
