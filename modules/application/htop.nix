{config, lib, pkgs, ...}:

let
  cfg = config.host.application.htop;
in
{
  options = {
    host.application.htop = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables htop";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      htop
    ];
  };
}
