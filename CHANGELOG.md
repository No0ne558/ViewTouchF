# Changelog

All notable changes to **ViewTouchF** (ViewTouch Food Truck) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.7.2] — 2026-04-06

### Fixed
- **Menu delete persistence**: deleting a menu item now reliably persists across restarts — all menu CRUD methods save to the database *before* updating in-memory state so a failed write never causes DB/memory desync
- **Duplicate modifier IDs**: demo menu data reused modifier IDs across items (e.g. MOD01 in both Classic Burger and Cheese Burger), causing the SQLite PRIMARY KEY to silently drop duplicates; each item now has unique modifier IDs
- **Flutter modifier ID collisions**: the admin menu editor's sequential counters (`MG1`, `MOD1`, …) reset every session, guaranteeing collisions after the first item; now generates random hex IDs (e.g. `MOD_a3f2b1c0`)
- **Demo re-seeding on empty menu**: deleting all menu items caused the demo to re-seed on restart; now uses a persistent `menu_seeded` database flag — once set, the demo is never re-seeded
- **RAII transaction guard**: all transactional database methods (`save_menu`, `save_ticket`, `save_report`, migrations) now use an RAII guard that auto-rolls-back on exception, preventing stuck open transactions
- **Menu RPC error reporting**: `AddMenuItem`, `UpdateMenuItem`, and `DeleteMenuItem` now catch exceptions and return `INTERNAL` with the actual error message instead of gRPC's generic `UNKNOWN`

## [2.7.1] — 2026-04-06

### Fixed
- **Deadlock-free shutdown**: daemon shutdown no longer triggers gRPC 1.48's abseil deadlock detector — signal handlers and the RPC shutdown callback now only set an `atomic<bool>` flag; a dedicated watcher thread polls the flag and calls `Shutdown()` from a clean thread context
- **Stale socket on startup**: daemon removes leftover `/opt/viewtouchf/run/pos.sock` before binding so a previous crash or unclean exit doesn't block restart
- **Fedora Asahi Remix detection**: `build.sh` now matches `fedora-asahi-remix` (and any other Fedora variant) with a `fedora*` glob in the distro case pattern

## [2.7.0] — 2026-04-04

### Added
- **Shutdown button** in Admin Panel → Settings: stops both the Flutter UI and the C++ daemon with a confirmation dialog
- New `Shutdown` gRPC RPC — daemon responds with success, then gracefully shuts down on a short delay so the client receives the response
- `PosServiceImpl::set_shutdown_callback()` — daemon wires up `g_server->Shutdown()` via callback

## [2.6.1] — 2026-04-04

### Added
- **Versioned schema migrations**: `Database` now tracks schema version via SQLite `PRAGMA user_version` and runs numbered migrations on startup — safe incremental upgrades across any number of releases
- Migration dispatch loop in `Database::migrate()` with per-version functions (`migrate_to_1()`, …); new migrations just add a function and bump `kLatestVersion`
- Migrations are transactional: each version applied in its own `BEGIN … COMMIT` so a failure leaves the DB at the last good version
- Startup log shows `schema vN → vM — running migrations` or silently skips when already current

## [2.6.0] — 2026-04-04

### Added
- **SQLite persistence**: all POS state (menu, tickets, phone orders, archived reports, settings, sequences) now persists across daemon restarts via a WAL-mode SQLite database at `<data-dir>/data/viewtouchf.db`
- New `Database` class (`include/core/database.h`, `src/core/database.cpp`) — RAII SQLite wrapper with prepared-statement CRUD for 12 tables
- `PosManager::set_database()` / `load_from_database()` — wires DB at startup and restores all state
- Demo menu is only seeded on first run (empty DB); subsequent restarts reload from the database
- `build.sh` installs `sqlite-devel` / `libsqlite3-dev` / `sqlite` for Fedora / Ubuntu / Arch

## [2.5.0] — 2026-04-04

### Added
- **Install to `/opt/viewtouchf`**: new `./build.sh install` command copies daemon and Flutter UI to `/opt/viewtouchf/bin/` and creates the directory structure for persistent data
- **Data directory structure**: `/opt/viewtouchf/{data,menu,config,logs,run}` — daemon auto-creates subdirectories on startup
- **`--data-dir` daemon flag**: daemon accepts `--data-dir <path>` to override the install root (defaults to `/opt/viewtouchf`)
- Socket file now lives at `/opt/viewtouchf/run/pos.sock` (was `/tmp/viewtouch/pos.sock`)
- `./build.sh run` auto-detects installed location and runs from `/opt/viewtouchf` if present, otherwise falls back to build tree

## [2.4.0] — 2026-04-04

### Added
- **Cart item +/− buttons**: replaced swipe-left/right gestures with explicit minus (−), plus (+), and trash icon buttons per cart item for clearer touch interaction
- **Tappable quantity counter**: tap the quantity number between +/− to open a numeric keypad for entering a custom quantity
- **Trash icon with confirmation**: trash button removes an item immediately if quantity ≤ 2, or shows a confirmation dialog for larger quantities
- **Drag-to-scroll on check**: cart list now supports finger/mouse/trackpad drag scrolling on Linux desktop via `ScrollConfiguration` with all pointer device kinds
- **Auto-scroll to bottom**: cart automatically scrolls to the newest item when an item is added

### Changed
- Dollar amounts now display with commas for thousands (e.g. `$1,234.56`) via shared `formatMoney()` utility used across all screens

## [2.3.1] — 2026-04-04

### Changed
- `build.sh` now handles full zero-to-running setup — auto-detects distro (Fedora, Debian/Ubuntu, Arch), installs system packages, Flutter SDK, and Dart protoc plugin
- New `./build.sh setup` command for dependency installation only
- New `./build.sh run` command starts daemon + UI together (UI exit stops daemon)
- Flutter PATH automatically added to shell profile (~/.bashrc / ~/.zshrc)
- Correct architecture detection (x64/arm64) for Flutter build output paths

## [2.3.0] — 2026-04-04

### Added
- **Tap cart item to re-modify**: tapping a line item in the ticket panel opens the modifier dialog pre-populated with its current selections, allowing in-place editing of modifiers and special instructions via the new `UpdateItem` RPC
- **Special Instructions**: new button in modifier dialog (left of Add to Order / Update Item) opens the touchscreen keyboard to type per-item special instructions — displayed in the cart with a memo icon, printed bold on receipts and kitchen tickets
- **Edit Order for phone orders**: new blue "Edit Order" button in the phone order list restores the ticket for editing while keeping the phone order on hold, so staff can add/remove items before checkout

### Changed
- Reason dialog (VOID/COMP/REFUND) now uses `TouchKeyboardDialog` popup instead of an embedded keyboard
- Phone Order dialog replaced embedded keyboard with tap-to-edit fields — tapping Name or Comment opens a full `TouchKeyboardDialog` popup for a consistent keyboard experience across the app

### Fixed
- Tapping a cart item to edit modifiers now works correctly — modifier groups are looked up from the full menu instead of the slim ticket copy which lacked them

## [2.2.2] — 2026-04-04

### Changed
- Custom date range picker replaced with a full calendar dialog — year dropdown (2020–present), month dropdown, arrow navigation, and day grid with range highlighting
- Daily report date picker replaced with matching calendar dialog for consistent UX
- Future dates grayed out and disabled in both pickers

## [2.2.1] — 2026-04-04

### Changed
- Keyboard dialog widened from 900px to 1100px with increased button spacing for easier touchscreen use
- Space bar and Backspace keys now use dark blueGrey backgrounds with white text for better contrast
- Replaced `-` key with `:` on the keyboard bottom row

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

[2.2.2]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.2.2
[2.2.1]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.2.1
[2.2.0]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.2.0
[2.1.0]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.1.0
[2.0.0]: https://github.com/No0ne558/ViewTouchF/releases/tag/v2.0.0
