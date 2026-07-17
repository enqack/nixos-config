{ config, lib, pkgs, ... }:
let
  cfg = config.modules.hardware.printing;
in
{
  options.modules.hardware.printing = {
    enable = lib.mkEnableOption "hardware printing configuration";
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

    services.ipp-usb = {
      enable = true;
    };
  };
}
