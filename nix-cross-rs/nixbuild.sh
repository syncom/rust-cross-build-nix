#!/bin/sh
# This script is to be invoked inside the container

cd /build/RUST_PROJECT_NAME && \
    nix-shell shell.nix \
      --run "cd /build/RUST_PROJECT_NAME && \
             rustup toolchain install $(cat rust-toolchain) && \
             cargo install cross --git file:///build/cross && \
             mkdir -p out && \
             CROSS_CONTAINER_ENGINE=podman cross build --release --target aarch64-unknown-linux-musl && \
             cp target/aarch64-unknown-linux-musl/release/hello-random out/hello-random-aarch64-linux && \
             CROSS_CONTAINER_ENGINE=podman cross build --release --target armv7-unknown-linux-musleabihf && \
             cp target/armv7-unknown-linux-musleabihf/release/hello-random out/hello-random-armv7-linux && \
             CROSS_CONTAINER_ENGINE=podman cross build --release --target x86_64-unknown-linux-musl && \
             cp target/x86_64-unknown-linux-musl/release/hello-random out/hello-random-x86_64-linux && \
             CROSS_CONTAINER_ENGINE=podman cross build --release --target arm-unknown-linux-musleabihf && \
             cp target/arm-unknown-linux-musleabihf/release/hello-random out/hello-random-arm-linux"
