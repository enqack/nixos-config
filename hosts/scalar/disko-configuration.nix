{ device ? "/dev/sda", ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
            };
          };

          boot = {
            size = "2G";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/boot";
            };
          };

          root = {
            size = "878900M";
            content = {
              type = "btrfs";
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [ "subvol=@" ];
                };
              };
            };
          };

          swap = {
            size = "64500M";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
              randomEncryption = true;
            };
          };
        };
      };
    };
  };
}
