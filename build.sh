#!/usr/bin/env bash
# build.sh — Install dependencies and build ViewTouchF from zero.
#
# Usage:
#   ./build.sh              # install deps + build everything
#   ./build.sh setup        # install system & Flutter dependencies only
#   ./build.sh daemon       # build C++ daemon only
#   ./build.sh flutter      # build Flutter UI only
#   ./build.sh proto-dart   # regenerate Dart proto stubs
#   ./build.sh run          # start daemon + UI

set -euo pipefail
cd "$(dirname "$0")"

ROOT="$PWD"
BUILD_DIR="$ROOT/build"
FLUTTER_DIR="$HOME/flutter"

# ── Color helpers ─────────────────────────────────────────────
green() { printf '\033[1;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[1;33m%s\033[0m\n' "$*"; }
red() { printf '\033[1;31m%s\033[0m\n' "$*"; }

# ── Detect distro ────────────────────────────────────────────
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# ── Install system packages ──────────────────────────────────
install_system_deps() {
    local distro
    distro=$(detect_distro)
    green "==> Detected distro: $distro"

    case "$distro" in
        fedora|rhel|centos)
            green "==> Installing system packages (dnf)..."
            sudo dnf install -y \
                cmake gcc-c++ grpc-devel protobuf-devel protobuf-compiler \
                cups-devel git pkg-config clang ninja-build \
                gtk3-devel libX11-devel libXrandr-devel libXinerama-devel \
                libXcursor-devel mesa-libGL-devel mesa-libEGL-devel
            ;;
        ubuntu|debian|pop|linuxmint)
            green "==> Installing system packages (apt)..."
            sudo apt update
            sudo apt install -y \
                cmake g++ libgrpc++-dev protobuf-compiler-grpc \
                libcups2-dev git pkg-config clang ninja-build \
                libgtk-3-dev libx11-dev libxrandr-dev libxinerama-dev \
                libxcursor-dev libgl-dev libegl-dev
            ;;
        arch|manjaro)
            green "==> Installing system packages (pacman)..."
            sudo pacman -S --needed --noconfirm \
                cmake gcc grpc protobuf cups git pkgconf clang ninja \
                gtk3 libx11 libxrandr libxinerama libxcursor mesa
            ;;
        *)
            red "==> Unknown distro '$distro'. Install these manually:"
            echo "    cmake, g++/gcc-c++, grpc-devel, protobuf-devel,"
            echo "    cups-devel, git, pkg-config, clang, ninja-build,"
            echo "    gtk3-devel, libX11-devel"
            return 1
            ;;
    esac
    green "==> System packages installed."
}

# ── Install Flutter SDK ──────────────────────────────────────
install_flutter() {
    if command -v flutter &>/dev/null; then
        green "==> Flutter already installed: $(flutter --version | head -1)"
    else
        green "==> Installing Flutter SDK to $FLUTTER_DIR..."
        if [ -d "$FLUTTER_DIR" ]; then
            yellow "    $FLUTTER_DIR exists but flutter not in PATH."
        else
            git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
        fi
        export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
        green "==> Flutter installed: $(flutter --version | head -1)"
    fi

    # Ensure PATH includes Flutter for this session
    export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"

    # Enable Linux desktop
    flutter config --enable-linux-desktop 2>/dev/null || true

    # Pre-cache Linux build artifacts
    flutter precache --linux 2>/dev/null || true
}

# ── Install Dart protoc plugin ───────────────────────────────
install_protoc_plugin() {
    if command -v protoc-gen-dart &>/dev/null; then
        green "==> protoc-gen-dart already installed."
    else
        green "==> Installing Dart protoc plugin..."
        dart pub global activate protoc_plugin
        green "==> protoc-gen-dart installed."
    fi
}

# ── Add Flutter to shell profile ─────────────────────────────
ensure_path_in_profile() {
    local shell_rc=""
    case "$SHELL" in
        */zsh)  shell_rc="$HOME/.zshrc" ;;
        */bash) shell_rc="$HOME/.bashrc" ;;
        *)      shell_rc="$HOME/.profile" ;;
    esac

    local path_line="export PATH=\"\$HOME/flutter/bin:\$HOME/flutter/bin/cache/dart-sdk/bin:\$HOME/.pub-cache/bin:\$PATH\""
    if ! grep -qF 'flutter/bin' "$shell_rc" 2>/dev/null; then
        echo "" >> "$shell_rc"
        echo "# Flutter SDK (added by ViewTouchF build.sh)" >> "$shell_rc"
        echo "$path_line" >> "$shell_rc"
        yellow "==> Added Flutter to $shell_rc — restart your shell or run:"
        yellow "    source $shell_rc"
    fi
}

# ── Setup (install all dependencies) ─────────────────────────
setup() {
    green "============================================"
    green "  ViewTouchF — Full Setup from Zero"
    green "============================================"
    install_system_deps
    install_flutter
    install_protoc_plugin
    ensure_path_in_profile
    green "==> All dependencies installed!"
}

# ── Build targets ─────────────────────────────────────────────
build_daemon() {
    green "==> Building C++ daemon..."
    mkdir -p "$BUILD_DIR"
    cmake -B "$BUILD_DIR" -S "$ROOT" \
          -DCMAKE_BUILD_TYPE=Release
    cmake --build "$BUILD_DIR" -j"$(nproc)"
    green "==> Daemon binary: $BUILD_DIR/vt_daemon"
}

build_proto_dart() {
    green "==> Generating Dart proto stubs..."
    export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
    local out="$ROOT/flutter_ui/lib/generated"
    mkdir -p "$out"
    protoc \
        --proto_path="$ROOT/proto" \
        --dart_out="grpc:$out" \
        "$ROOT/proto/pos_service.proto"
    green "==> Dart stubs written to $out"
}

build_flutter() {
    green "==> Building Flutter UI..."
    export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
    cd "$ROOT/flutter_ui"
    flutter pub get
    flutter build linux --release
    local arch
    arch=$(uname -m)
    [[ "$arch" == "aarch64" ]] && arch="arm64" || arch="x64"
    green "==> Flutter binary: flutter_ui/build/linux/$arch/release/bundle/viewtouch_ui"
}

# ── Run (start daemon + UI) ──────────────────────────────────
run() {
    export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
    local arch
    arch=$(uname -m)
    [[ "$arch" == "aarch64" ]] && arch="arm64" || arch="x64"

    local daemon="$BUILD_DIR/vt_daemon"
    local ui="$ROOT/flutter_ui/build/linux/$arch/release/bundle/viewtouch_ui"

    if [[ ! -x "$daemon" ]]; then
        red "==> Daemon not built. Run: ./build.sh all"
        exit 1
    fi
    if [[ ! -x "$ui" ]]; then
        red "==> Flutter UI not built. Run: ./build.sh all"
        exit 1
    fi

    mkdir -p /tmp/viewtouch
    green "==> Starting daemon..."
    "$daemon" &
    local daemon_pid=$!
    sleep 1

    green "==> Starting UI..."
    VT_SOCKET=/tmp/viewtouch/pos.sock "$ui"

    # When UI exits, stop daemon
    kill "$daemon_pid" 2>/dev/null || true
    green "==> Done."
}

# ── Main dispatch ─────────────────────────────────────────────
case "${1:-all}" in
    setup)      setup ;;
    daemon)     build_daemon ;;
    flutter)    build_flutter ;;
    proto-dart) build_proto_dart ;;
    run)        run ;;
    all)
        setup
        build_daemon
        build_proto_dart
        build_flutter
        green ""
        green "============================================"
        green "  Build complete! Run with: ./build.sh run"
        green "============================================"
        ;;
    *)
        echo "Usage: $0 {setup|daemon|flutter|proto-dart|run|all}"
        exit 1
        ;;
esac
