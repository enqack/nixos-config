{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix
    ../../modules/base/env
    ../../modules/base/nix
    ../../modules/base/networking
    ../../modules/base/users
    ../../modules/services/acpi
    ../../modules/services/logind
    ../../modules/services/nix-index
    ../../modules/services/plymouth-config
    ../../modules/services/ssh
    ../../modules/services/xserver
    ../../modules/system/auto-upgrade
    ../../modules/system/boot
    ../../modules/system/garbage-collection
    ../../modules/system/issue
    ../../modules/system/time
    ../../modules/hardware/bluetooth
    ../../modules/hardware/graphics
    ../../modules/hardware/sound
    ../../modules/ui/console
    ../../modules/ui/fonts
  ];

  modules.base.env.enable = true;
  modules.base.nix.enable = true;
  modules.base.networking.enable = true;
  modules.base.users.enable = true;
  modules.services.acpi.enable = true;
  modules.services.logind.enable = true;
  modules.services.nix-index.enable = true;
  modules.services.plymouth-config.enable = true;
  modules.services.ssh.enable = true;
  modules.services.xserver.enable = true;
  modules.system.auto-upgrade.enable = true;
  modules.system.boot.enable = true;
  modules.system.garbage-collection.enable = true;
  modules.system.issue.enable = true;
  modules.system.time.enable = true;
  modules.hardware.bluetooth.enable = true;
  modules.hardware.graphics.enable = true;
  modules.hardware.sound.enable = true;
  modules.ui.console.enable = true;
  modules.ui.fonts.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
}
