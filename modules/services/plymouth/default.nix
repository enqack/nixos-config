{ config, lib, pkgs, ... }:

let
  plymouth = pkgs.plymouth;
in
{
  options.services.plymouth = {
    enable = lib.mkEnableOption "Plymouth splash screen during boot";

    # Option for configuring GRUB timeout
    grubTimeout = lib.mkOption {
      type = lib.types.number;
      default = 0;
      description = "Time in seconds to wait at the GRUB menu. Set to 0 to hide the menu.";
    };

    # Option for specifying the Plymouth theme
    theme = lib.mkOption {
      type = lib.types.str;
      default = "bgrt";
      description = "The Plymouth theme to use for the splash screen";
    };
  };

  config = lib.mkIf config.services.plymouth.enable {
    # Ensure Plymouth and its themes are available
    environment.systemPackages = [ plymouth ];

    # Initrd and boot settings
    boot.initrd = {
      availableKernelModules = [ "drm" "i915" ];
      kernelModules = [ "drm" ];
      extraUtilsCommandsTest = ''
        command -v ${plymouth}/bin/plymouthd || exit 1
      '';
      extraUtilsCommands = ''
        copy_bin_and_libs ${pkgs.kbd}/bin/setfont
      '';
      verbose = false;
    };

    boot.kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    boot.consoleLogLevel = 0;

    # Set GRUB loader configuration directly
    boot.loader.timeout = config.services.plymouth.grubTimeout;  # Default is 0 unless set in configuration
    boot.loader.grub = {
      enable = true;
      extraPrepareConfig = ''
        echo "set plymouth=1" >> $OUT
        echo "set gfxpayload=keep" >> $OUT
      '';
    };

    # Configure the Plymouth service itself
    boot.plymouth = {
      enable = true;
      theme = config.services.plymouth.theme;
    };

    systemd.services."plymouth-wait-for-animation" = {
      description = "Waits for Plymouth animation to finish";
      before = [ "plymouth-quit.service" "display-manager.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/sleep 5";
      };
      wantedBy = [ "plymouth-start.service" ];
    };

    # Ensure the framebuffer is set up for smooth graphics rendering
    services.xserver.videoDrivers = [ "modesetting" ];
  };
}

