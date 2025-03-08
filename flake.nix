{
  description = "Example Virtual Machine Configuration";
  inputs =  {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
  };
  outputs = { self, nixpkgs }@inputs: {
    nixosConfigurations = {
      # configuration for builidng qcow2 images
      build-qcow2 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./configurations/sim
          ./configurations/node
        ];
      };

      # configuration for the iso image
      build-iso = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./configurations/iso
        ];
      };

    };
  };
}
