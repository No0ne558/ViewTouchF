# Multi-stage build for vt_daemon
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake pkg-config git ca-certificates \
    protobuf-compiler protobuf-compiler-grpc libprotobuf-dev libgrpc++-dev \
    libssl-dev libsqlite3-dev libre2-dev libcups2-dev libavahi-client-dev libgnutls28-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . /src

# Build vt_daemon
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
 && cmake --build build --target vt_daemon -- -j$(nproc)

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates sqlite3 && rm -rf /var/lib/apt/lists/*

RUN groupadd -r viewtouch && useradd -r -g viewtouch -d /nonexistent -s /usr/sbin/nologin viewtouch

COPY --from=builder /src/build/vt_daemon /usr/local/bin/vt_daemon

RUN mkdir -p /opt/viewtouchf/data /opt/viewtouchf/run /opt/viewtouchf/menu /opt/viewtouchf/logs \
 && chown -R viewtouch:viewtouch /opt/viewtouchf

USER viewtouch
WORKDIR /opt/viewtouchf

ENTRYPOINT ["/usr/local/bin/vt_daemon"]
CMD ["--data-dir", "/opt/viewtouchf"]
