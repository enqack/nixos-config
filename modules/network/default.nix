{ lib, ... }:
  with lib;
{
  imports = [
    ./firewall
    ./hostname.nix
    ./wired.nix
  ];
}
