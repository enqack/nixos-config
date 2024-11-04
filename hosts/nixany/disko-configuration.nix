{ lib, ... }:

{
  disko.devices = {
    disk = {
      "disk0" = {
        device = "/dev/sda";
        type = "disk";     
        content = {
          type = "gpt";
          
          partitions = {
            # EFI Partition within /boot
            efi = {
              start = "0MiB";
              end = "512MiB";
              type = "c12a7328-f81f-11d2-ba4b-00a0c93ec93b";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
              };
            };

            # Boot Partition
            boot = {
              start = "512MiB";
              end = "1024MiB";
              type = "0fc63daf-8483-4772-8e79-3d69d8477de4";
              priority = 2;
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/boot";
              };
            };

            # Swap Partition
            swap = {
              start = "1024MiB";
              end = "9216MiB";
              type = "0657fd6d-a4ab-43c4-84e5-0933c84b4f4f";
              priority = 3;
              content = {
                type = "filesystem";
                format = "swap";
              };
            };

            # Root Partition
            rootfs = {
              start = "9216MiB";
              end = "100%";
              type = "0fc63daf-8483-4772-8e79-3d69d8477de4";
              priority = 4;
              content = {
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
