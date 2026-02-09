# The following information is from https://hub.docker.com/r/nixos/nix/tags
FROM nixos/nix:2.33.2@sha256:c6ebd12d96b3374ee15e3986c15aa43f5e49310634f17afcaaf4dafe4f6732b2 AS rust-overlay_builder

###################################################################
# Step 1: Prepare nixpkgs and rust-overlay for deterministic builds
###################################################################
WORKDIR /build
# Custom project name
ENV RUST_PROJECT_NAME="rust-cross-build-nix"

# nixpkgs 25.11
ENV NIXPKGS_COMMIT_SHA="871b9fd269ff6246794583ce4ee1031e1da71895"
# rust-overlay version 20260205 with latest rust-bin.stable 1.93.0
ENV RUST_OVERLAY_COMMIT_SHA="42ec85352e419e601775c57256a52f6d48a39906"

# Apple M1 workaround
COPY nix.conf /build/nix.conf
ENV NIX_USER_CONF_FILES=/build/nix.conf

RUN mkdir -p /build/nixpkgs && \
    cd nixpkgs && \
    git init && \
    git remote add origin https://github.com/NixOS/nixpkgs.git && \
    git fetch --depth 1 origin ${NIXPKGS_COMMIT_SHA} && \
    git checkout FETCH_HEAD && \
    cd .. && \
    git clone https://github.com/oxalica/rust-overlay.git && \
    cd rust-overlay && \
    git checkout ${RUST_OVERLAY_COMMIT_SHA} && \
    cd .. && \
    mkdir -p /build/${RUST_PROJECT_NAME}/out

ENV NIX_PATH=nixpkgs=/build/nixpkgs:rust-overlay=/build/rust-overlay

#########################################################
# Step 2: Prepare Nix Shells for Caching
#########################################################
COPY nix-rust-overlay/shell-x86_64-win.nix /build/${RUST_PROJECT_NAME}/shell-x86_64-win.nix
COPY nix-rust-overlay/shell-x86_64.nix /build/${RUST_PROJECT_NAME}/shell-x86_64.nix
COPY nix-rust-overlay/shell-i686.nix /build/${RUST_PROJECT_NAME}/shell-i686.nix
COPY nix-rust-overlay/shell-aarch64.nix /build/${RUST_PROJECT_NAME}/shell-aarch64.nix
COPY nix-rust-overlay/shell-armv7.nix /build/${RUST_PROJECT_NAME}/shell-armv7.nix
COPY nix-rust-overlay/shell-armv6.nix /build/${RUST_PROJECT_NAME}/shell-armv6.nix

# Warm up the cache layers
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-x86_64-win.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-x86_64.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-aarch64.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-armv6.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-armv7.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-i686.nix

#########################################################
# Step 3: Cross builds for various targets
#########################################################
COPY src /build/${RUST_PROJECT_NAME}/src
COPY Cargo.toml /build/${RUST_PROJECT_NAME}/Cargo.toml
COPY Cargo.lock /build/${RUST_PROJECT_NAME}/Cargo.lock
COPY nix-rust-overlay/Makefile /build/${RUST_PROJECT_NAME}/Makefile

# For 64-bit platforms
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-x86_64-win.nix --show-trace \
      --run "TARGET=x86_64-pc-windows-gnu make && \
      TARGET=x86_64-pc-windows-gnu make run"
# echo to NOP qemu commands to get around issue on Apple M1
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-x86_64.nix \
      --run "TARGET=x86_64-unknown-linux-musl make && \
             echo TARGET=x86_64-unknown-linux-musl make run"
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-aarch64.nix \
      --run "TARGET=aarch64-unknown-linux-musl make && \
             echo TARGET=aarch64-unknown-linux-musl make run"
# For 32-bit platforms
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-armv6.nix \
      --run "TARGET=arm-unknown-linux-musleabihf make && \
             echo TARGET=arm-unknown-linux-musleabihf make run"
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-armv7.nix \
      --run "TARGET=armv7-unknown-linux-musleabihf make && \
             echo TARGET=armv7-unknown-linux-musleabihf make run"
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-i686.nix \
      --run "TARGET=i686-unknown-linux-musl make && \
             echo TARGET=i686-unknown-linux-musl make run"
