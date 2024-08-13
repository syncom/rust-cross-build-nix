# h/t https://github.com/oxalica/rust-overlay/tree/master/examples/cross-aarch64
# When invoking with `nix-shell`, add "rust-overlay=/path/to/rust-overlay/dir"
# to $NIX_PATH
(import <nixpkgs> {
  crossSystem = {
    config = "x86_64-w64-mingw32";
  };
  overlays = [ (import <rust-overlay>) ];
}).callPackage (
{ mkShell, stdenv, rust-bin, windows, wine64, pkg-config }:
mkShell {
  nativeBuildInputs = [
    rust-bin.stable."1.77.0".minimal
    pkg-config
  ];

  depsBuildBuild = [ wine64 ];

  buildInputs = [ windows.pthreads ];

  CARGO_TARGET_X86_64_PC_WINDOWS_GNU_LINKER = "${stdenv.cc.targetPrefix}cc";
  CARGO_TARGET_X86_64_PC_WINDOWS_GNU_RUNNER = "wine64";
}) {}