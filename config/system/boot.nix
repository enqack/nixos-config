{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader = {
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.useOSProber = true;
    # grub.splashImage = "/home/sysop/nix-bootloader.png";
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
