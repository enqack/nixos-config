{ config, pkgs, lib, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    optimise.automatic = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      max-jobs = "auto";
      sandbox = true;
      keep-outputs = true;
      keep-derivations = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
      trusted-users = [ "@wheel" ];
    };
  };
  programs.nix-ld.enable = true;
}

