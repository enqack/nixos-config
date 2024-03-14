{config, lib, pkgs, ...}:

let
  cfg = config.host.application.tree;
in
{
  options = {
    host.application.tree = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables tree";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tree
    ];
  };
}
