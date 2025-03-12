
make-vm-diskoImages:
    nom build .#nixosConfigurations.build-qcow2.config.system.build.diskoImagesScript
    ./result --build-memory 8192

make-vm-qcow:
    qemu-img convert -f raw -O qcow2 main.raw ./provision/sim/image.qcow2

make-vm: make-vm-diskoImages make-vm-qcow

vm-test-shell:
    #https://superuser.com/questions/1087859/how-to-quit-the-qemu-monitor-when-not-using-a-gui
    qemu-system-x86_64 \
      -drive file=./provision/sim/image.qcow2,format=qcow2 \
      -m 8192 \
      -serial mon:stdio \
      -nographic


make-iso:
    nix build .#nixosConfigurations.build-iso.config.system.build.isoImage \
      --out-link provision/physical/iso
    echo "ISO image built in provision/physical/iso"
