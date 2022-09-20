# h/t https://github.com/oxalica/rust-overlay/tree/master/examples/cross-aarch64
# When invoking with `nix-shell`, add "rust-overlay=/path/to/rust-overlay/dir"
# to $NIX_PATH
(import <nixpkgs> {
  crossSystem = "armv6l-linux";
  overlays = [ (import <rust-overlay>) ];
}).pkgsMusl.pkgsStatic.callPackage (
{ mkShell, stdenv, rust-bin, pkg-config, openssl, qemu }:
mkShell {
  nativeBuildInputs = [
    rust-bin.stable.latest.minimal
    pkg-config
  ];

  depsBuildBuild = [ qemu ];

  buildInputs = [ openssl ];

  CARGO_TARGET_ARM_UNKNOWN_LINUX_MUSLEABIHF_LINKER = "${stdenv.cc.targetPrefix}cc";
  CARGO_TARGET_ARM_UNKNOWN_LINUX_MUSLEABIHF_RUNNER = "qemu-arm";
}) {}
