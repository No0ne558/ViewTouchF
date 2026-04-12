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
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run --all-files; \
	else \
		echo "pre-commit not found; install with 'pip3 install --user pre-commit'"; exit 1; \
	fi

.PHONY: docker-image package package-deb package-rpm

docker-image:
	docker build -t viewtouchf/daemon:latest -f docker/daemon/Dockerfile .

package-deb:
	@echo "Building .deb package (requires dpkg-deb)"
	@./packaging/deb/build-deb.sh

package-rpm:
	@echo "Building .rpm package (requires rpmbuild)"
	@./packaging/rpm/build-rpm.sh

package: package-deb package-rpm
	@echo "Packages built in dist/ and packaging/rpm/rpmbuild/RPMS"
