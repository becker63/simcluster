{ pkgs }:
pkgs.writeShellApplication {
  name = "make-iso-image";
  text = ''
    set -e
    nix build .#nixosConfigurations.build-iso.config.system.build.isoImage \
      --out-link provision/physical/iso
    echo "ISO image built in provision/physical/iso"
  '';
}
