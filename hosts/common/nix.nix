{ lib, inputs, outputs, pkgs, ... }:

{
  nix = {
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "19:00";
      persistent = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 10d";
    };
 
    settings = {
      warn-dirty = false;
      accept-flake-config = true;
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      # show more log lines for failed builds
      log-lines = 30;
      # Free up to 10GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 thrice
      min-free = lib.mkDefault "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = lib.mkDefault "${toString (10 * 1024 * 1024 * 1024)}";
      max-jobs = lib.mkDefault "auto";
      trusted-users = [ "root" "@wheel" ];
    };
  };

  nixpkgs = {
    config = {
      allowBroken = lib.mkDefault false;
      allowUnfree = lib.mkDefault true;
      allowUnsupportedSystem = lib.mkDefault true;
      permittedInsecurePackages = [
      ];
    };
  };

  system = {
    stateVersion = lib.mkDefault "23.11";
    autoUpgrade.enable = lib.mkDefault false;
  };   
}
