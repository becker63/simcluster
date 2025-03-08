{
  description = "Example Virtual Machine Configuration";
  inputs =  {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
  };
  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      # configuration for builidng qcow2 images
      build-qcow2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configurations/sim
          ./configurations/node
          ./qcow.nix
        ];
      };
    };
  };
}
