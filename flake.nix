{
  description = "A basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    disko.url = "github:nix-community/disko";
    systems.url = "github:nix-systems/default";
  };

  outputs = { systems, nixpkgs, disko, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      pkgs = import nixpkgs {
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        build-qcow2 = nixpkgs.lib.nixosSystem {
          modules = [
            ./configurations/hardware/sim
            disko.nixosModules.disko
            ./configurations/hardware/disko
            ./configurations/node
            disko.nixosModules.disko
            (
              { config, ... }:
              {
                disko.devices.disk.main.imageSize = "10G";
              }
            )
          ];
        };

        build-iso = nixpkgs.lib.nixosSystem {
          modules = [ ./configurations/iso ];
        };
      };
    };
}
