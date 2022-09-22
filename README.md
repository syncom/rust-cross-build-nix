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

## Approach 2

[nix-rust-overlay](./nix-rust-overlay/)

## How to Build Using Both Approaches

In the directory root of the repository

```bash
make
```

Clean up with command

```bash
make clean
```
