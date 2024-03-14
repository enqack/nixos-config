{config, lib, pkgs, ...}:

let
  cfg = config.host.application.bat;
in
{
  options = {
    host.application.bat = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables a better cat";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat
    ];
  };
}
