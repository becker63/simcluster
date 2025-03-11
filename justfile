make-boot-image:
    nix build .#nixosConfigurations.build-qcow2.config.system.build.diskoImages --out-link provision/sim/image
    echo "Boot image built at provision/sim/image"

make-iso:
    nix build .#nixosConfigurations.build-iso.config.system.build.isoImage \
      --out-link provision/physical/iso
    echo "ISO image built in provision/physical/iso"
