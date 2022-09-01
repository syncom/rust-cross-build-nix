# Reproducible Rust Cross Builds with rust-overlay

This approach to deterministically building statically linked Rust binaries is
based on [Nix](https://github.com/NixOS/nixpkgs) and
[rust-overlay](https://github.com/oxalica/rust-overlay).

## How to build

In the directory root of the repository

```bash
make rust-overlay
# `make ro-clean` to clean up
```
