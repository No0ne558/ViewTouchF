# ViewTouch v2 — POS System

**ViewTouch v2** is an open-source Point of Sale system for high-volume restaurants, built with a **Flutter** touch-first frontend and a **C++17** backend daemon communicating over **gRPC** (Unix domain socket).

## Architecture Overview

```
┌─────────────────────┐       gRPC / UDS        ┌──────────────────────┐
│   Flutter UI         │◄──────────────────────►│   vt_daemon (C++17)  │
│   (Dart / Linux)     │  unix:///tmp/viewtouch/ │                      │
│                      │        pos.sock         │  ┌──────────────┐   │
│  RegisterScreen      │                         │  │  PosManager   │   │
│  MenuGrid            │                         │  │  (tickets,    │   │
│  TicketPanel         │                         │  │   menu, tax)  │   │
└─────────────────────┘                         │  └──────────────┘   │
                                                 │  ┌──────────────┐   │
                                                 │  │  CupsPrinter  │──►CUPS ──► Thermal Printer
                                                 │  │  (ESC/POS)    │   │
                                                 │  └──────────────┘   │
                                                 └──────────────────────┘
```

## Directory Layout

```
ViewTouchF/
├── CMakeLists.txt              # C++ build (daemon + core lib)
├── build.sh                    # One-command build script
├── proto/
│   └── pos_service.proto       # gRPC service contract
├── include/
│   ├── core/
│   │   ├── menu_item.h
│   │   ├── ticket.h
│   │   └── pos_manager.h
│   ├── printing/
│   │   └── cups_printer.h
│   └── server/
│       └── pos_service_impl.h
├── src/
│   ├── core/                   # Business logic (no gRPC deps)
│   ├── printing/               # CUPS + ESC/POS
│   └── server/                 # gRPC daemon entry point
├── flutter_ui/                 # Flutter frontend
│   ├── lib/
│   │   ├── main.dart
│   │   ├── generated/          # protoc-gen-dart output
│   │   ├── services/           # gRPC client wrapper
│   │   ├── screens/            # Full-page screens
│   │   └── widgets/            # Reusable UI components
│   └── pubspec.yaml
└── deploy/
    └── vt-daemon.service       # systemd unit file
```

## Prerequisites

### Fedora
```bash
sudo dnf install cmake g++ grpc-devel grpc-plugins protobuf-devel cups-devel
```

### Debian / Pop!_OS
```bash
sudo apt install cmake g++ libgrpc++-dev protobuf-compiler-grpc libcups2-dev
```

### Dart proto plugin
```bash
dart pub global activate protoc_plugin
```

### Flutter
```bash
# Install Flutter SDK: https://docs.flutter.dev/get-started/install/linux
flutter doctor
```

## Building

```bash
# Build everything (daemon + dart stubs + flutter UI)
./build.sh

# Or individual targets:
./build.sh daemon       # C++ daemon only
./build.sh proto-dart   # Regenerate Dart gRPC stubs
./build.sh flutter      # Flutter Linux app only
```

## Running

```bash
# 1. Start the daemon
mkdir -p /tmp/viewtouch
./build/vt_daemon

# 2. In another terminal, run the Flutter UI
cd flutter_ui && flutter run -d linux
```

## Production Deployment

```bash
sudo cp build/vt_daemon /opt/viewtouch/
sudo cp deploy/vt-daemon.service /etc/systemd/system/
sudo useradd -r -s /sbin/nologin -G lp vt
sudo systemctl daemon-reload
sudo systemctl enable --now vt-daemon
```

## License

Open source — license TBD.
