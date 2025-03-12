{
  disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/nvme1n1";
          content = {
            type = "gpt";
            partitions = {
              biosBoot = {
                size = "2M";
                type = "EF02";
                # no filesystem content needed
              };
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
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
          postCreateHook =
            "zfs list -t snapshot -H -o name | grep -E '^rpool/local/root@blank$' || zfs snapshot rpool/local/root@blank";

          datasets = {
            local = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            safe = {
              type = "zfs_fs";
              options.mountpoint = "none";
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
  }
