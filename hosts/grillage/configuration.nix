# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    host = {
      role = "server";
      network = {
        hostname = "grillage";
      };
    };
  };
}
