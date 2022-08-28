# Reproducible Rust Cross Builds with cross-rs

This approach to deterministically building statically linked Rust binaries is
based on [cross](https://github.com/cross-rs/cross) and
[Nix](https://github.com/NixOS/nixpkgs), where the former does the heavy-lifting
for cross-building, and the latter makes the builds reproducible.

## How to build

```bash
cd nix-cross-rs
make
# `make clean` to clean up
```
