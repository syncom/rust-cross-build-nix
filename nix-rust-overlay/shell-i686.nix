# h/t https://github.com/oxalica/rust-overlay/tree/master/examples/cross-aarch64
# When invoking with `nix-shell`, add "rust-overlay=/path/to/rust-overlay/dir"
# to $NIX_PATH
(import <nixpkgs> {
  crossSystem = "i686-linux";
  overlays = [ (import <rust-overlay>) ];
}).pkgsMusl.pkgsStatic.callPackage (
{ mkShell, stdenv, rust-bin, pkg-config, openssl, qemu }:
mkShell {
  nativeBuildInputs = [
    rust-bin.stable."1.76.0".minimal
    pkg-config
  ];

  depsBuildBuild = [ qemu ];

  buildInputs = [ openssl ];

  CARGO_TARGET_I686_UNKNOWN_LINUX_MUSL_LINKER = "${stdenv.cc.targetPrefix}cc";
  CARGO_TARGET_I686_UNKNOWN_LINUX_MUSL_RUNNER = "qemu-i386";
}) {}
