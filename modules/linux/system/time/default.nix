{ config, lib, pkgs, ... }:
let
  cfg = config.modules.system.time;
in
{
  options.modules.system.time = {
    enable = lib.mkEnableOption "system time configuration";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "America/New_York";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };
}
