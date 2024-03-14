{config, lib, pkgs, ...}:

let
  cfg = config.host.application.vim;
in
{
  options = {
    host.application.vim = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables vim";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
    ];
  };
}
