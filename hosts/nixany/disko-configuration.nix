{ device ? "/dev/sda", lib, ... }:

{
  disko.devices = {
    disk = {
      main = {
        name = "main";
        device = device;
        type = "disk";

        content = {
          type = "gpt";
          
          partitions = {

            # EFI Partition within /boot
            efi = {
              size = "512M";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
              };
            };

            # Boot Partition
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

            # Swap Partition
            swap = {
              size = "8192M";
              priority = 3;
              content = {
                type = "swap";
              };
            };

            # Root Partition
            root = {
              size = "100%";
              priority = 4;
              content = {
                extraArgs = [ "-f" ]; # Override existing partition
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
              };
            };
          };

        };
      };
    };
  };
}
