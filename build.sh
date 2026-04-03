#!/usr/bin/env bash
# build.sh — Build the C++ daemon and (optionally) the Flutter UI.
#
# Usage:
#   ./build.sh              # build everything
#   ./build.sh daemon       # build C++ daemon only
#   ./build.sh flutter      # build Flutter UI only
#   ./build.sh proto-dart   # regenerate Dart proto stubs
#
# Prerequisites:
#   sudo dnf install cmake g++ grpc-devel protobuf-devel cups-devel   # Fedora
#   sudo apt install cmake g++ libgrpc++-dev protobuf-compiler-grpc \
#                    libcups2-dev                                      # Debian
#   dart pub global activate protoc_plugin                             # Dart

set -euo pipefail
cd "$(dirname "$0")"

ROOT="$PWD"
BUILD_DIR="$ROOT/build"

build_daemon() {
    echo "==> Building C++ daemon..."
    mkdir -p "$BUILD_DIR"
    cmake -B "$BUILD_DIR" -S "$ROOT" \
          -DCMAKE_BUILD_TYPE=Release
    cmake --build "$BUILD_DIR" -j"$(nproc)"
    echo "==> Daemon binary: $BUILD_DIR/vt_daemon"
}

build_proto_dart() {
    echo "==> Generating Dart proto stubs..."
    local out="$ROOT/flutter_ui/lib/generated"
    mkdir -p "$out"
    protoc \
        --proto_path="$ROOT/proto" \
        --dart_out="grpc:$out" \
        "$ROOT/proto/pos_service.proto"
    echo "==> Dart stubs written to $out"
}

build_flutter() {
    echo "==> Building Flutter UI..."
    cd "$ROOT/flutter_ui"
    flutter pub get
    flutter build linux --release
    echo "==> Flutter binary: flutter_ui/build/linux/x64/release/bundle/"
}

case "${1:-all}" in
    daemon)     build_daemon ;;
    flutter)    build_flutter ;;
    proto-dart) build_proto_dart ;;
    all)
        build_daemon
        build_proto_dart
        build_flutter
        ;;
    *)
        echo "Usage: $0 {daemon|flutter|proto-dart|all}"
        exit 1
        ;;
esac
