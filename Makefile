SHELL := /bin/bash
NPROC := $(shell nproc 2>/dev/null || echo 2)

.PHONY: all build build-daemon build-cli build-ui clean test lint

all: build

build: build-daemon build-cli

build-daemon:
	cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
	cmake --build build --target vt_daemon -- -j$(NPROC)

build-cli:
	cd cli && go build -v -o ../bin/vtctl .

build-ui:
	cd flutter_ui && flutter pub get
	cd flutter_ui && flutter build linux --release

clean:
	rm -rf build
	if [ -d flutter_ui ]; then cd flutter_ui && flutter clean || true; fi
	rm -rf bin

test:
	cd flutter_ui && flutter test

lint:
	@echo "No linter configured. Add clang-format and dart format targets as needed."
