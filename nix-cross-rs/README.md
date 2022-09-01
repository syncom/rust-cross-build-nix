# Reproducible Rust Cross Builds with cross-rs

This approach to deterministically building statically linked Rust binaries is
based on [cross](https://github.com/cross-rs/cross) and
[Nix](https://github.com/NixOS/nixpkgs), where the former does the heavy-lifting
for cross-building, and the latter makes the builds reproducible.

## How to build

In the directory root of the repository

```bash
make cross-rs
# `make cr-clean` to clean up
```
