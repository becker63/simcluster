{ lib, pkgs, config, modulesPath, ... }:
{
  networking.hostId = "4e98920d";

  boot.kernelParams = [ "console=ttyS0" ];
  systemd.services."getty@ttyS0".enable = true;


  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.package = pkgs.zfs_unstable;
  boot.zfs.devNodes = "/dev";
  services.zfs.autoScrub.enable = true;

  # Read the external script file.
  boot.initrd.postDeviceCommands = builtins.readFile ./generate-hostid.sh;

  systemd.services.zfsPoolImport = {
    description = "Import ZFS pools after hostid generation";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.zfs}/bin/zpool import -a";
    };
  };

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.devices = [ "nodev" ];

  system.build.qcow2 = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = "8192";
    format = "qcow2";
    partitionTableType = "efi";
  };

}
