#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VERSION="${1:-0.0.1}"
RPMBUILD_DIR="$REPO_ROOT/packaging/rpm/rpmbuild"

rm -rf "$RPMBUILD_DIR"
mkdir -p "$RPMBUILD_DIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

TARBALL="$RPMBUILD_DIR/SOURCES/viewtouchf-${VERSION}.tar.gz"
TMPDIR="$(mktemp -d)"
mkdir -p "$TMPDIR/opt/viewtouchf/bin"

if [ ! -f "$REPO_ROOT/build/vt_daemon" ]; then
  echo "Error: built binary not found at build/vt_daemon. Run 'make build-daemon' first." >&2
  exit 2
fi

cp "$REPO_ROOT/build/vt_daemon" "$TMPDIR/opt/viewtouchf/bin/"
tar -C "$TMPDIR" -czf "$TARBALL" opt
rm -rf "$TMPDIR"

SPEC="$REPO_ROOT/packaging/rpm/viewtouchf.spec"
if [ ! -f "$SPEC" ]; then
  echo "Spec file not found: $SPEC" >&2
  exit 2
fi

rpmbuild --define "_topdir $RPMBUILD_DIR" -ba "$SPEC"
echo "RPMs in $RPMBUILD_DIR/RPMS"
