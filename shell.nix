{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:
let
  make-boot-image = pkgs.writeShellScriptBin "make-boot-image" ''
      nix-build -o sim/image '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ sim/config/build-qcow2.nix ]; }"
  '';
  apiKey = builtins.getEnv "MY_API_KEY";
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # software for deployment
    colmena
    jq
    terraform
    terraform-providers.libvirt
    libxslt


    # scripts
    make-boot-image
  ];
  shellHook = ''
      export MY_API_KEY="${apiKey}"
    '';
}
