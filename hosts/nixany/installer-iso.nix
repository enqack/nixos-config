#$ nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=./installer-iso.nix
{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];

  # Enable SSH in the live environment
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  users.users.root = {
    password = "root";
  };

  environment.systemPackages = with pkgs; [
    curl git gparted parted tmux vim wget
  ];
}

