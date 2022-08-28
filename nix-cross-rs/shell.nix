{ pkgs ? import <nixpkgs> {} }:

let

  # To use this shell.nix on NixOS your user needs to be configured as such:
  users.extraUsers.root = {
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  # Provides a script that copies required files to ~/
  podmanSetupScript = let
    registriesConf = pkgs.writeText "registries.conf" ''
      [registries.search]
      registries = ['docker.io']

      [registries.block]
      registries = []
    '';
  in pkgs.writeScript "podman-setup" ''
    #!${pkgs.runtimeShell}

    # Dont overwrite customised configuration
    if ! test -f ~/.config/containers/policy.json; then
      install -Dm555 ${pkgs.skopeo.src}/default-policy.json ~/.config/containers/policy.json
    fi

    if ! test -f ~/.config/containers/registries.conf; then
      install -Dm555 ${registriesConf} ~/.config/containers/registries.conf
    fi
  '';

in pkgs.mkShell {

  buildInputs = [
    pkgs.rustup
    pkgs.gcc
    pkgs.podman  # Docker compat
    pkgs.runc  # Container runtime
    pkgs.conmon  # Container runtime monitor
    pkgs.skopeo  # Interact with container registry
    pkgs.slirp4netns  # User-mode networking for unprivileged namespaces
    pkgs.fuse-overlayfs  # CoW for images, much faster than default vfs
  ];

  shellHook = ''
    # Install required configuration
    ${podmanSetupScript}
    mkdir -p /opt/cni
    ln -s ${pkgs.cni-plugins}/bin /opt/cni/bin
  '';

}