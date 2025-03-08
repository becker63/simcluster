{
  description = "Example flake with extracted Shell Apps";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.11";

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    # Import pkgs
    pkgs = import nixpkgs {
      inherit system;
    };

    # Import the shell apps from separate files
    buildImageApp = import ./apps/build-image.nix { inherit pkgs; };
    buildISOApp   = import ./apps/build-iso.nix   { inherit pkgs; };
  in {
    # Example NixOS configs
    nixosConfigurations = {
      build-qcow2 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configurations/sim
          ./configurations/node
        ];
      };

      build-iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configurations/iso ];
      };
    };

    # Packages
    packages.${system} = {
      buildImage = buildImageApp;
      buildISO  = buildISOApp;
    };
  };
}
