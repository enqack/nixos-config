{ config, pkgs, lib, ... }:
let
  homeManagerSkeleton = pkgs.callPackage ../../../pkgs/skeletons/home-manager-skeleton/default.nix {};
in
{
  config = {
    environment.systemPackages = with pkgs; [
      homeManagerSkeleton
    ];

    # Define a systemd service that sets up the skeleton
    systemd.user.services.setup-skeleton = {
      unitConfig = {
        Description = "Install skeleton files on first login";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'cp -r ${homeManagerSkeleton}/* $HOME/'";
      };
      wantedBy = [ "default.target" ];
    };
  };
}

