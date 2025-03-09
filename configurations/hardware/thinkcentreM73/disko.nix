{
  lib,
  config,
  ...
}: let
  cfg = config.rs-homelab;
in {
  options = {
    rs-homelab.bootDrive = lib.mkOption {
      type = lib.types.str;
      default = "nvme1n1";
      example = "by-id/nvme-KINGSTON_OM3PGP41024P-A0_50026B7283642E53";
      description = "The boot drive of the system. It's best to use a disk ID as PCIe names can change.";
    };
  };

  config = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/" + cfg.bootDrive;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              root = {
                size = "100%";
                type = "8300";
                content = {
                  type = "zfs";
                  pool = "rpool";
                };
              };
            };
          };
        };
      };

      zpool = {
        rpool = {
          type = "zpool";
          options = {
            ashift = "12";
            autotrim = "on";
          };
          rootFsOptions = {
            canmount = "off";
            dnodesize = "auto";
            normalization = "formD";
            relatime = "on";
            xattr = "sa";
            mountpoint = "none";
          };
          # Post-creation hook to ensure a baseline snapshot exists for recovery purposes.
          postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/local/root@blank$' || zfs snapshot rpool/local/root@blank";

          datasets = {
            local = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            safe = {
              type = "zfs_fs";
              options.mountpoint = "none";
              # Note that you must set the `com.sun:auto-snapshot`
              # property to `true` on all datasets which you wish
              # to auto-snapshot.
              options."com.sun:auto-snapshot" = "true";
            };
            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
            };
            "safe/persist" = {
              type = "zfs_fs";
              mountpoint = "/persist";
            };
            "safe/home" = {
              type = "zfs_fs";
              mountpoint = "/home";
            };
          };
        };
      };
    };

    fileSystems."/persist".neededForBoot = true;
  };
}
