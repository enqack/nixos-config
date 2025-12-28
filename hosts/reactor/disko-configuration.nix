{ rootfs ? "/dev/sda", homefs ? "/dev/sdb", ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = rootfs;
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
            size = "100%";
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
    
    disk.home = {
      type = "disk";
      device = homefs;
      content = {
        type = "gpt";
        partitions = {
          home = {
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes = {
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "subvol=@" ];
                };
              };
            };
          };
        }; 
      };
    };
  };
}
