{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.sysstat;
in
{
  options.modules.services.sysstat = {
    enable = lib.mkEnableOption "services sysstat configuration";
  };

  config = lib.mkIf cfg.enable {
    services.sysstat = {
      enable = true;
      collect-args = "-S XALL 1 1";
    };

    environment.systemPackages = with pkgs; [
      sysstat
    ];
  };
}
