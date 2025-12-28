{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = {
    enable = lib.mkEnableOption "services ssh configuration";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
    
    systemd.services.openssh = {
      enable = true;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };
}
