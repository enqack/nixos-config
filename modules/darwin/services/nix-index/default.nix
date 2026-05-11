{ config, lib, pkgs, ... }:
let
  cfg = config.modules.services.nix-index;
in
{
  options.modules.services.nix-index = {
    enable = lib.mkEnableOption "services nix-index configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nix-index ];

    launchd.daemons.nix-index-update = {
      script = ''
        exec ${pkgs.coreutils}/bin/nice -n 19 ${pkgs.nix-index}/bin/nix-index
      '';
      serviceConfig = {
        Label     = "org.nixos.nix-index-update";
        RunAtLoad = false;
        Nice      = 19;

        #SoftResourceLimits.RSS = 6442450944;

        StartCalendarInterval = [{ Weekday = 0; Hour = 3; Minute = 0; }];

        StandardOutPath   = "/var/log/nix-index-update.log";
        StandardErrorPath = "/var/log/nix-index-update.log";
      };
    };
  };
}
