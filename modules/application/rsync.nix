{config, lib, pkgs, ...}:

let
  cfg = config.host.application.rsync;
in
{
  options = {
    host.application.rsync = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables remote syncing tool";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rsync
    ];

    ## TODO Add bash aliases
  };
}
