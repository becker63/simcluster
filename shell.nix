{
  description = "A Nix Flake for building a bootable QCOW2 image";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    # Define a NixOS configuration that builds a QCOW2 image
    nixosConfigurations.qcow2Image = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ ./provision/sim/config/build-qcow2.nix ];
    };

    # Expose the QCOW2 image as a flake package
    packages.${system}.bootImage = pkgs.writeShellScriptBin "make-boot-image" ''
      nix build .#nixosConfigurations.qcow2Image.config.system.build.qcow2Image
      mkdir -p provision/sim/image
      ln -sf result provision/sim/image
      echo "Boot image built at provision/sim/image"
    '';
  };
}
