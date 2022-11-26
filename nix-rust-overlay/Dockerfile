# The following information is from https://hub.docker.com/r/nixos/nix/tags
FROM nixos/nix:2.9.0@sha256:13b257cd42db29dc851f9818ea1bc2f9c7128c51fdf000971fa6058c66fbe4b6 as cross-rs_builder

###################################################################
# Step 1: Prepare nixpkgs and rust-overlay for deterministic builds
###################################################################
WORKDIR /build
# Custom project name
ENV RUST_PROJECT_NAME="rust-cross-build-nix"

# nixpkgs 22.05
ENV NIXPKGS_COMMIT_SHA="ce6aa13369b667ac2542593170993504932eb836"
# rust-overlay version 20220827
ENV RUST_OVERLAY_COMMIT_SHA="0c4c1432353e12b325d1472bea99e364871d2cb3"

# Apple M1 workaround
COPY nix.conf /build/nix.conf
ENV NIX_USER_CONF_FILES=/build/nix.conf

RUN nix-env -i git && \
    mkdir -p /build/nixpkgs && \
    cd nixpkgs && \
    git init && \
    git remote add origin https://github.com/NixOS/nixpkgs.git && \
    git fetch --depth 1 origin ${NIXPKGS_COMMIT_SHA} && \
    git checkout FETCH_HEAD && \
    cd .. && \
    mkdir -p /build/cross && \
    git clone https://github.com/oxalica/rust-overlay.git && \
    cd rust-overlay && \
    git checkout ${CROSS_COMMIT_SHA} && \
    cd .. && \
    mkdir -p /build/${RUST_PROJECT_NAME}/out

ENV NIX_PATH=nixpkgs=/build/nixpkgs:rust-overlay=/build/rust-overlay

#########################################################
# Step 2: Prepare Nix Shells for Caching
#########################################################
COPY nix-rust-overlay/shell-x86_64-win.nix /build/${RUST_PROJECT_NAME}/shell-x86_64-win.nix
COPY nix-rust-overlay/shell-x86_64.nix /build/${RUST_PROJECT_NAME}/shell-x86_64.nix
COPY nix-rust-overlay/shell-aarch64.nix /build/${RUST_PROJECT_NAME}/shell-aarch64.nix
COPY nix-rust-overlay/shell-armv7.nix /build/${RUST_PROJECT_NAME}/shell-armv7.nix
COPY nix-rust-overlay/shell-armv6.nix /build/${RUST_PROJECT_NAME}/shell-armv6.nix
# Copy patch for musl-1.1.24
COPY nix-rust-overlay/musl-1.1.24.patch /build/musl-1.1.24.patch

# Warm up the cache layers
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-x86_64-win.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-x86_64.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-aarch64.nix
# Use musl-1.1.24 for 32-bit platforms, to work around a cross building issue
# similar to the one discussed in
# https://stackoverflow.com/questions/61934997/undefined-reference-to-stat-time64-when-cross-compiling-rust-project-on-mu
RUN cd /build/nixpkgs && git apply /build/musl-1.1.24.patch
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-armv6.nix
RUN cd /build/${RUST_PROJECT_NAME} && \
      nix-shell shell-armv7.nix

#########################################################
# Step 3: Cross builds for various targets
#########################################################
COPY src /build/${RUST_PROJECT_NAME}/src
COPY Cargo.toml /build/${RUST_PROJECT_NAME}/Cargo.toml
COPY Cargo.lock /build/${RUST_PROJECT_NAME}/Cargo.lock
COPY nix-rust-overlay/Makefile /build/${RUST_PROJECT_NAME}/Makefile

# Revert the musl-1.1.24 patch because we don't need it for 64-bit platforms
RUN cd /build/nixpkgs && git apply -R /build/musl-1.1.24.patch
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
# Re-apply the musl-1.1.24 patch for 32-bit platforms
RUN cd /build/nixpkgs && git apply /build/musl-1.1.24.patch
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-armv6.nix \
      --run "TARGET=arm-unknown-linux-musleabihf make && \
             echo TARGET=arm-unknown-linux-musleabihf make run"
RUN cd /build/${RUST_PROJECT_NAME} && \
    nix-shell shell-armv7.nix \
      --run "TARGET=armv7-unknown-linux-musleabihf make && \
             echo TARGET=armv7-unknown-linux-musleabihf make run"
