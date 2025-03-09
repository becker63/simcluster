{
  description = "packages and build scripts";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.11";

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Import the shell apps from separate files
    buildImageApp = import ./apps/build-image.nix { inherit pkgs; };
    buildISOApp   = import ./apps/build-iso.nix   { inherit pkgs; };
  in {
    nixosConfigurations = {
      build-qcow2 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configurations/hardware/sim
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

    devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            terraform
            terraform-providers.libvirt
            libxslt
            qemu
          ];

          shellHook = ''
              # https://discourse.nixos.org/t/nix-shell-does-not-use-my-users-shell-zsh/5588/13
              # https://ianthehenry.com/posts/how-to-learn-nix/nix-zshell/
              # tldr idc just start it on top of bash
              zsh
          '';
        };
  };
}
