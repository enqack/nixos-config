{ config, inputs, outputs, lib, pkgs, ... }:
let
  cfg = config.host.feature.home-manager;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options = {
    host.feature.home-manager = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enable Home manager to provide isolated home configurations per user";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      home-manager
    ];

    home-manager.extraSpecialArgs = { inherit inputs outputs; };
  };
}
