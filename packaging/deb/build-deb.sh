#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VERSION="${1:-0.0.1}"
ARCH="$(dpkg --print-architecture 2>/dev/null || echo "all")"
BUILDROOT="$REPO_ROOT/packaging/deb/buildroot"
OUTDIR="$REPO_ROOT/dist"

rm -rf "$BUILDROOT"
mkdir -p "$BUILDROOT/opt/viewtouchf/bin"
mkdir -p "$BUILDROOT/DEBIAN"
mkdir -p "$OUTDIR"

if [ ! -f "$REPO_ROOT/build/vt_daemon" ]; then
  echo "Error: built binary not found at build/vt_daemon. Run 'make build-daemon' first." >&2
  exit 2
fi

cp "$REPO_ROOT/build/vt_daemon" "$BUILDROOT/opt/viewtouchf/bin/"

cat > "$BUILDROOT/DEBIAN/control" <<EOF
Package: viewtouchf
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Maintainer: ViewTouchF maintainers <maintainers@localhost>
Depends: libc6, libstdc++6, libsqlite3-0
Description: ViewTouchF daemon
 ViewTouchF point-of-sale daemon.
EOF

chmod 0755 "$BUILDROOT/DEBIAN"
dpkg-deb --build "$BUILDROOT" "$OUTDIR/viewtouchf_${VERSION}_${ARCH}.deb"
echo "Created: $OUTDIR/viewtouchf_${VERSION}_${ARCH}.deb"
