Contributing to ViewTouchF
=========================

Thanks for helping improve ViewTouchF — we appreciate contributions of all
sizes. This document gives a short, practical guide to getting started, the
project workflow, and how to run the automated checks.

Quickstart
----------

Prerequisites (development machine):

- `git`, `cmake`, `make`, `gcc`/`g++`
- Go toolchain (`go`) for the CLI
- Flutter SDK for `flutter_ui` development
- Python 3 and `pip3` for pre-commit hooks

Helpful Makefile targets (from repo root):

```bash
# Build daemon (CMake) and CLI
make build-daemon
make build-cli

# Build Flutter UI (requires Flutter installed)
make build-ui

# Run all checks (requires pre-commit installed)
make lint

# Run Flutter tests
make test
```

Pre-commit (formatting & basic checks)
------------------------------------

We use `pre-commit` to keep formatting and basic checks consistent. Install
it locally and enable the git hook:

```bash
# Fedora (install pip3 if needed):
sudo dnf install -y python3-pip

# install pre-commit
python3 -m pip install --user pre-commit
export PATH="$HOME/.local/bin:$PATH"

# enable the git hook
pre-commit install

# run checks once across the repo
pre-commit run --all-files
```

If a hook fails, `pre-commit` usually formats/fixes files. Re-run
`pre-commit run --all-files` and commit the fixes.

Build & run (local)
-------------------

Start the daemon using a writable data directory (example uses a temp dir):

```bash
./build/vt_daemon --data-dir /tmp/viewtouchf_test &
# check socket
bin/vtctl status --socket /tmp/viewtouchf_test/run/pos.sock
```

Run the Flutter UI (use `VT_SOCKET` to point at the daemon socket):

```bash
VT_SOCKET=/tmp/viewtouchf_test/run/pos.sock flutter_ui/build/linux/arm64/release/bundle/viewtouch_ui
```

Run the CLI (example):

```bash
bin/vtctl status --socket /tmp/viewtouchf_test/run/pos.sock
bin/vtctl seed-demo --data-dir /tmp/viewtouchf_test --daemon ./build/vt_daemon
```

Tests & analyzer
----------------

For Flutter code:

```bash
cd flutter_ui
flutter pub get
flutter analyze
flutter test
```

Pull Request & branch workflow
-----------------------------

- Create a short-lived feature branch: `feat/<short-desc>` or `fix/<short-desc>`.
- Keep PRs small and focused; include tests where applicable.
- Ensure `pre-commit` hooks pass and tests/analyzer pass before requesting review.

PR checklist (suggested):

- [ ] Code builds locally
- [ ] Pre-commit checks pass (`make lint`)
- [ ] Tests pass (`make test` / `flutter test`)
- [ ] Relevant docs updated

Reporting issues / security
--------------------------

For security-sensitive issues, see `SECURITY.md` if present; otherwise open a
private/security issue on GitHub or email the maintainers.

Thanks — we look forward to your contributions!
