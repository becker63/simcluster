{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
let
  make-boot-image = pkgs.writeShellScriptBin "make-boot-image" ''
      nix-build -o machines/snode/image '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ ./machines/snode/config/build-qcow2.nix ]; }"
  '';

in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # software for deployment
    colmena
    jq
    terraform
    terraform-providers.libvirt


    # scripts
    make-boot-image
  ];
}
