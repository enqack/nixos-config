{ device ? "/dev/sda", ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = device;
        content = {
          type = "gpt";
          partitions = {
            efi = {
              size = "512M";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
              };
            };
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "mainpool";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      mainpool = {
        type = "lvm_vg";
        lvs = {
          thinpool = {
            size = "64G";
            lvm_type = "thin-pool";
            priority = 2;
          };
          boot = {
            size = "1024M";
            lvm_type = "thinlv";
            pool = "thinpool";
            priority = 3;
            content = {
              extraArgs = [ "-f" ]; # Override existing partition
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "32G";
            lvm_type = "thinlv";
            pool = "thinpool";
            priority = 4;
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
          home = {
            size = "24GB";
            lvm_type = "thinlv";
            pool = "thinpool";
            priority = 5;
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/home";
            };
          };
        };
      };
    };
  };
}

