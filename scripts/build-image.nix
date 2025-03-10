{ pkgs }:
pkgs.writeShellApplication {
  name = "make-boot-image";
  text = ''
    set -e
    nix build .#nixosConfigurations.build-qcow2.config.system.build.diskoImages \
      --out-link provision/sim/image
    echo "Boot image built at provision/sim/image"
  '';
}
