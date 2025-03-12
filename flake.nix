{
  description = "packages and build scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    disko.url = "github:nix-community/disko";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      buildImageApp = import ./scripts/build-image.nix { inherit pkgs; };
      buildISOApp = import ./scripts/build-iso.nix { inherit pkgs; };
    in
    {

      nixosConfigurations = {
        build-qcow2 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configurations/hardware/sim
            disko.nixosModules.disko
            ./configurations/hardware/disko
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
        buildISO = buildISOApp;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nix-output-monitor
          terraform
          terraform-providers.libvirt
          libxslt
          qemu
          libvirt
          tree
        ];

        shellHook = ''
          # Starting zsh on top of bash for a consistent shell experience
          zsh
        '';
      };
    };
}
