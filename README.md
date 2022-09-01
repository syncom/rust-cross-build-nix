# Cross Building Rust Project in Nix

This repository demonstrates "one-click" ways of cross building Rust code. We
use Nix to do the builds, so the artifacts are more likely to be (bit-for-bit)
reproducible. The examples also statically link against `musl` libc, because
static linking is trickier to do, and because we can.

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
