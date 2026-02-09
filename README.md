# Reproducible, Statically Linked Rust Cross Builds in Nix

[![cross-rs builds](https://github.com/syncom/rust-cross-build-nix/actions/workflows/r10e-cross-rs-build.yml/badge.svg)](https://github.com/syncom/rust-cross-build-nix/actions/workflows/r10e-cross-rs-build.yml)
[![rusto-overlay builds](https://github.com/syncom/rust-cross-build-nix/actions/workflows/r10e-rust-overlay-build.yml/badge.svg)](https://github.com/syncom/rust-cross-build-nix/actions/workflows/r10e-rust-overlay-build.yml)

This repository demonstrates "one-click" ways of cross building Rust
code, deterministically. We use Nix to do the builds, and the artifacts
are bit-for-bit reproducible. The examples also statically link against
`musl` libc, because static linking is trickier to do, and because we
can.

You need Docker for building the examples.

## Approach 1

[nix-cross-rs](./nix-cross-rs/)

- This approach uses [cross-rs/cross](https://github.com/cross-rs/cross),
managed by Nix, for the cross builds. It requires running a container engine
(`podman`) inside a Docker container, and privileged access permissions.
Compared to the second approach, this one is less "pure" and conceptually more
complex. Hence this approach is less preferred.

## Approach 2

[nix-rust-overlay](./nix-rust-overlay/)

- This approach is "pure", in that it uses Nix to manage dependencies entirely.
- ~~It demonstrates how to statically link to `openssl` for the `unix` target
  family.~~ `openssl` static linking is a pain - we dropped the support.
- It demonstrates cross builds on a `windows` target

## How to Build Using Both Approaches

In the directory root of the repository

```bash
make
```

Or for either approach

```bash
# Approach 1
make cross-rs
# Approach 2
make rust-overlay
```

Clean up with command

```bash
make clean
```

Or for either approach

```bash
# Approach 1
make cr-clean
# Approach 2
make ro-clean
```
