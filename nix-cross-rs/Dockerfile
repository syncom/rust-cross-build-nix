# The following information is from https://hub.docker.com/r/nixos/nix/tags
FROM nixos/nix:2.9.0@sha256:13b257cd42db29dc851f9818ea1bc2f9c7128c51fdf000971fa6058c66fbe4b6 as cross-rs_builder

############################################################
# Step 1: Prepare nixpkgs and cross for deterministic builds
############################################################
WORKDIR /build
# Custom project name
ENV RUST_PROJECT_NAME="rust-cross-build-nix"

# This commit is tagged as 21.11 in nixpkgs
# ENV NIXPKGS_COMMIT_SHA="a7ecde854aee5c4c7cd6177f54a99d2c1ff28a31"
# 22.05
#ENV NIXPKGS_COMMIT_SHA="ce6aa13369b667ac2542593170993504932eb836"
# This version has podman 4.2.0, which contains bugfix
# https://github.com/containers/podman/pull/14787
ENV NIXPKGS_COMMIT_SHA="692574660e1f1e397b6e48065c931e8758c5ad16"
# 0.2.4
ENV CROSS_COMMIT_SHA="4645d937bdae6952d9df38eff3ecb91fd719c3bd"

# Apple M1 workaround
COPY nix.conf /build/nix.conf
ENV NIX_USER_CONF_FILES=/build/nix.conf

RUN nix-env --option filter-syscalls false -i git gnused && \
    mkdir -p /build/nixpkgs && \
    cd nixpkgs && \
    git init && \
    git remote add origin https://github.com/NixOS/nixpkgs.git && \
    git fetch --depth 1 origin ${NIXPKGS_COMMIT_SHA} && \
    git checkout FETCH_HEAD && \
    cd .. && \
    mkdir -p /build/cross && \
    git clone https://github.com/cross-rs/cross.git && \
    cd cross && \
    git checkout ${CROSS_COMMIT_SHA} && \
    cd .. && \
    mkdir -p /build/.cargo && \
    mkdir -p /build/.rustup && \
    mkdir -p /build/${RUST_PROJECT_NAME}

ENV NIX_PATH=nixpkgs=/build/nixpkgs
ENV RUSTC_VERSION=1.63.0
ENV CARGO_HOME="/build/.cargo"
ENV RUSTUP_HOME="/build/.rustup"
ENV PATH="${CARGO_HOME}/bin:${RUSTUP_HOME}/toolchains/${RUSTC_VERSION}-x86_64-unknown-linux-gnu/bin:${PATH}"

#########################################################
# Step 2: Prepare Rust project
#########################################################
COPY nix-cross-rs/src /build/${RUST_PROJECT_NAME}/src
COPY nix-cross-rs/Cargo.toml /build/${RUST_PROJECT_NAME}/Cargo.toml
COPY nix-cross-rs/Cross.toml /build/${RUST_PROJECT_NAME}/Cross.toml
COPY nix-cross-rs/Cargo.lock /build/${RUST_PROJECT_NAME}/Cargo.lock
COPY nix-cross-rs/rust-toolchain /build/${RUST_PROJECT_NAME}/rust-toolchain
COPY nix-cross-rs/nixbuild.sh /build/${RUST_PROJECT_NAME}/nixbuild.sh
COPY nix-cross-rs/shell.nix /build/${RUST_PROJECT_NAME}/shell.nix

# String substitution
RUN sed -i "s/RUST_PROJECT_NAME/${RUST_PROJECT_NAME}/g" /build/${RUST_PROJECT_NAME}/nixbuild.sh

ENTRYPOINT [ "/bin/sh", "-c", "exec /build/${RUST_PROJECT_NAME}/nixbuild.sh" ]
