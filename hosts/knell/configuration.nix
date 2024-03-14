# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, inputs, ... }:
let

in
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
    host = {
      role = "server";
      network = {
        hostname = "knell";
      };
      user.sysop.enable = true;
    };

    networking = {
      hostName = "knell";
    };
  };
}
