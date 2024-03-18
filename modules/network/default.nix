{ lib, ... }:
  with lib;
{
  imports = [
    ./domainname.nix
    ./firewall
    ./hostname.nix
    ./wired.nix
  ];
}
