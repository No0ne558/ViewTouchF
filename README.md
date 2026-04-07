<div align="center">

# ViewTouchF

**ViewTouch Food Truck — A modern, open-source Point of Sale system for food trucks & restaurants**

Built with **Flutter** (Linux) + **C++17** + **gRPC**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![C++17](https://img.shields.io/badge/C%2B%2B-17-blue.svg)]()
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg?logo=flutter)]()
[![gRPC](https://img.shields.io/badge/gRPC-protobuf-4285F4.svg)]()

</div>

---

## Overview

ViewTouchF is a full-stack POS system designed for food trucks, high-volume restaurants, and food service. A **C++17 daemon** handles all business logic, ticket management, and thermal printing, while a **Flutter touch-first frontend** provides the register interface, admin panel, and reporting — connected over **gRPC** through a Unix domain socket.

### Key Features

| Category | Details |
|---|---|
| **Register** | Touch-optimized menu grid, real-time ticket panel, swipe gestures for quantity |
| **Modifiers** | NO / ADD / EXTRA / LIGHT / SIDE / DOUBLE with per-modifier pricing |
| **Checkout** | On-screen keypad, split payments (cash + card), change calculation |
| **Past Orders** | View, filter, reprint, void, comp, or refund any closed ticket |
| **Printing** | Dual CUPS printers (receipt + kitchen), ESC/POS thermal formatting |
| **Reports** | Daily / Weekly / Monthly / Yearly / Custom range, item breakdown, print to receipt |
| **End of Day** | Z-Report generation, automatic print, ticket history cleared |
| **Admin** | Menu CRUD with modifier groups, tax rate, printer discovery & config |

---
 
---

## What's New (v2.8.0 — Recent)

### Highlights

- **Credit Card Fee**: New admin setting for a flat fee and percentage; the fee is applied at checkout, flows through the backend (stored on tickets), and is taxed. The UI displays the raw fee while the charged amount includes tax; receipts show a `CC Fee` line and a `GRAND` total.
- **Reports (Accounting)**: Reports now include **Subtotal**, **CC Fees**, and **Total Collected** summary cards; the summary card order was adjusted for accounting clarity. Item sales have been moved out of the main Reports tab and into the new *Menu Productivity* tab.
- **Menu Productivity**: New admin tab that ranks most-sold items with Daily / Weekly / Monthly / Yearly / Custom ranges. Sort by quantity (default) or by revenue; includes rank, item name, qty sold, and revenue columns.
- **End of Day / Z-Report**: `end_day()` now clears empty OPEN tickets (prevents phantom open checks). Z-Report now displays Subtotal, CC Fees, and Total Collected.
- **Database & Proto**: DB migration **v3** adds `subtotal_cents`, `cc_fee_total_cents`, and `total_collected_cents` to archived reports. Protobufs and Dart gRPC stubs were regenerated to include new report and CC fee fields.
- **Misc fixes**: Reuse of empty OPEN tickets on new ticket creation, modifier min/max persistence fixes, and correct change-due calculation that accounts for CC fees.

For full per-release details, see [CHANGELOG.md](CHANGELOG.md).

---

## Screenshots

### Register — Order Screen
Menu grid with categorized items and live ticket panel.

![Order Page](img/OrderPage.png)

### Modifier Popup
Per-modifier actions (NO / EXTRA / LIGHT / SIDE / DBL) with cooking temp radio group.

![Modifier Popup](img/ModifierPopup.png)

### Special Instructions
On-screen keyboard for per-item notes — no external keyboard needed.

![Special Instructions](img/SpecialInstructions.png)

### Checkout
Numeric keypad with split payment (Cash + Card), exact-amount shortcut, and change calculation.

![Checkout](img/CheckoutPopup.png)

### Order History
Filterable past-orders dialog — Closed, Voided, Comped, Refunded — with reprint/void/comp/refund actions.

![Order History](img/CheckOrderHistory.png)

### Phone Orders
Create phone orders with customer name and notes, then checkout, edit, or cancel when they arrive.

| Create | List | Manage |
|:---:|:---:|:---:|
| ![Phone Order Name](img/PhoneOrderName%26Comment.png) | ![Phone Order List](img/PhoneOrderList.png) | ![Phone Order Manage](img/ModifiePhoneOrder.png) |

### Admin — Settings
Restaurant name, tax rate, dual printer discovery (receipt + kitchen) with enable toggles.

![Settings](img/AdminPanelSettings.png)

### Admin — Menu Management
Full menu CRUD with category badges, modifier group counts, edit/delete per item.

![Menu List](img/MenuList.png)

### Menu Item Editor
Create or edit items with ID, name, price, category, send-to-kitchen toggle, and nested modifier groups.

| New Item | Edit with Modifiers |
|:---:|:---:|
| ![New Item](img/MenuCreation.png) | ![Edit Item](img/MenuItemModifierEditor.png) |

### Admin — Reports
Daily / Weekly / Monthly / Yearly / Custom range with revenue cards and item-sales breakdown.

![Reports](img/Reports.png)

### Admin — End of Day
Z-Report generation with automatic receipt print, plus monthly X-Report.

![End of Day](img/EndDay%26Report.png)

---

## Architecture

```
┌──────────────────────┐       gRPC / UDS        ┌──────────────────────┐
│                      │◄──────────────────────►│                      │
│    Flutter UI        │   unix:///tmp/viewtouch/ │   vt_daemon (C++17) │
│    (Dart / Linux)    │         pos.sock         │                      │
│                      │                          │   ┌──────────────┐  │
│  • RegisterScreen    │                          │   │  PosManager   │  │
│  • AdminPanel        │                          │   │  tickets,     │  │
│  • Reports           │                          │   │  menu, tax    │  │
│  • Checkout Dialog   │                          │   └──────────────┘  │
│  • Past Orders       │                          │   ┌──────────────┐  │
│                      │                          │   │  CupsPrinter  │──► Thermal
└──────────────────────┘                          │   │  (ESC/POS)    │    Printer
                                                  │   └──────────────┘  │
                                                  └──────────────────────┘
```

The daemon and UI communicate exclusively through a protobuf-defined gRPC service (`pos_service.proto`), making it straightforward to swap, extend, or test either side independently.

---

## Project Structure

```
ViewTouchF/
├── CMakeLists.txt                  # C++ build system
├── build.sh                        # One-command build script
├── CHANGELOG.md
│
├── proto/
│   └── pos_service.proto           # gRPC service contract (source of truth)
│
├── include/                        # C++ headers
│   ├── core/
│   │   ├── menu_item.h
│   │   ├── ticket.h
│   │   └── pos_manager.h
│   ├── printing/
│   │   └── cups_printer.h
│   └── server/
│       └── pos_service_impl.h
│
├── src/                            # C++ implementation
│   ├── core/                       #   Business logic (no gRPC deps)
│   ├── printing/                   #   CUPS + ESC/POS formatting
│   └── server/                     #   gRPC daemon entry point + handlers
│
├── flutter_ui/                     # Flutter frontend
│   ├── lib/
│   │   ├── main.dart
│   │   ├── generated/              #   protoc-gen-dart output
│   │   ├── services/               #   gRPC client wrapper
│   │   ├── screens/                #   RegisterScreen, AdminScreen
│   │   └── widgets/                #   MenuGrid, TicketPanel, admin tabs
│   ├── fonts/
│   ├── linux/                      #   GTK runner (fullscreen kiosk)
│   └── pubspec.yaml
│
└── deploy/
    └── vt-daemon.service           # systemd unit file
```

---

## Prerequisites

<table>
<tr><th>Fedora / RHEL</th><th>Debian / Ubuntu</th></tr>
<tr><td>

```bash
sudo dnf install \
  cmake gcc-c++ \
  grpc-devel grpc-plugins \
  protobuf-devel \
  cups-devel
```

</td><td>

```bash
sudo apt install \
  cmake g++ \
  libgrpc++-dev \
  protobuf-compiler-grpc \
  libcups2-dev
```

</td></tr>
</table>

**Dart protoc plugin** (required for generating Flutter gRPC stubs):

```bash
dart pub global activate protoc_plugin
```

**Flutter SDK** — follow the [official Linux install guide](https://docs.flutter.dev/get-started/install/linux), then verify with:

```bash
flutter doctor
```

---

## Building

Use the included build script to compile everything in one step:

```bash
./build.sh            # Build daemon + generate Dart stubs + build Flutter UI
```

Or target individual components:

```bash
./build.sh daemon       # C++ daemon only
./build.sh proto-dart   # Regenerate Dart gRPC stubs from proto
./build.sh flutter      # Flutter Linux release build only
```

**Manual build** (if preferred):

```bash
# C++ daemon
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)

# Dart proto stubs
protoc --proto_path=proto --dart_out=grpc:flutter_ui/lib/generated proto/pos_service.proto

# Flutter UI
cd flutter_ui && flutter pub get && flutter build linux --release
```

---

## Running

**1. Start the daemon:**

```bash
mkdir -p /tmp/viewtouch
./build/vt_daemon
```

**2. Start the Flutter UI** (in a separate terminal):

```bash
cd flutter_ui
flutter run -d linux
```

Or run the release binary directly:

```bash
./flutter_ui/build/linux/arm64/release/bundle/viewtouch_ui
```

> The daemon creates a Unix socket at `/tmp/viewtouch/pos.sock`. The Flutter UI connects to it automatically.

---

## Production Deployment

A systemd service file is included for running the daemon as a background service:

```bash
# Install the daemon binary
sudo mkdir -p /opt/viewtouch
sudo cp build/vt_daemon /opt/viewtouch/

# Create a dedicated service user (with printer access)
sudo useradd -r -s /sbin/nologin -G lp vt

# Install and enable the service
sudo cp deploy/vt-daemon.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now vt-daemon
```

The Flutter UI can be deployed as a standard Linux desktop application or launched in kiosk mode on a POS terminal.

---

## gRPC API

The full API is defined in [`proto/pos_service.proto`](proto/pos_service.proto). Key RPCs:

| RPC | Description |
|---|---|
| `GetMenu` / `AddMenuItem` / `UpdateMenuItem` / `DeleteMenuItem` | Menu CRUD |
| `NewTicket` / `GetTicket` / `AddItem` / `RemoveItem` / `DecreaseItem` | Ticket management |
| `Checkout` | Close ticket with split payment support |
| `ListTickets` / `TicketAction` | Past orders, void/comp/refund |
| `PrintReceipt` / `PrintKitchen` | Thermal printing |
| `GetDailyReport` / `GetDateRangeReport` / `PrintReport` | Reporting |
| `EndDay` | Z-Report + clear day |
| `GetSettings` / `UpdateSettings` / `ListPrinters` | Configuration |

---

## Tech Stack

| Component | Technology |
|---|---|
| Backend | C++17, CMake, gRPC, Protobuf |
| Frontend | Flutter 3.x (Linux desktop), Dart |
| IPC | gRPC over Unix domain socket |
| Printing | CUPS, ESC/POS protocol |
| Proto | Protocol Buffers 3 |
| Deployment | systemd |

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of all changes.

---

## License

This project is licensed under the **GNU General Public License v3.0** — see the [LICENSE](LICENSE) file for details.
