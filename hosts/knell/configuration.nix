# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  options = {
    hostname = lib.mkOption {
      type = lib.types.string;
    };
  };

  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  config = {
    networking = {
      hostName = "knell"; 
      #wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      networkmanager.enable = true;
    };
  };
}
