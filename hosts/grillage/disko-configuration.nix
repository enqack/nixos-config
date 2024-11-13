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
            boot = {
              size = "1024M";
              priority = 2;
              content = {
                extraArgs = [ "-f" ]; # Override existing partition
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/boot";
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
          root = {
            size = "128G";
            priority = 3;
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
            size = "128G";
            priority = 4;
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
