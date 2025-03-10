{
  description = "packages and build scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    disko.url = "github:nix-community/disko";
    disko-images.url = "github:becker63/disko-images";
  };

  outputs = { self, nixpkgs, disko, disko-images, ... }:
  let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    platforms = {
          buildPlatform = "x86_64-linux";
          hostPlatform = "x86_64-linux";
        };

    buildImageApp = import ./scripts/build-image.nix { inherit pkgs; };
    buildISOApp   = import ./scripts/build-iso.nix   { inherit pkgs; };
  in {
    disko-images.emulateUEFI = true;
    nixosConfigurations = {
      build-qcow2 = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit (platforms) buildPlatform hostPlatform;
        modules = [
          ./configurations/hardware/sim
          disko.nixosModules.disko
          disko-images.nixosModules.disko-images
          ./configurations/hardware/disko
          ./configurations/node
        ];
      };

      build-iso = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit (platforms) buildPlatform hostPlatform;
        modules = [ ./configurations/iso ];
      };
    };

    # Packages
    packages.${system} = {
      buildImage = buildImageApp;
      buildISO  = buildISOApp;
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        terraform
        terraform-providers.libvirt
        libxslt
        qemu
        tree
      ];

      shellHook = ''
        # Starting zsh on top of bash for a consistent shell experience
        zsh
      '';
    };
  };
}
