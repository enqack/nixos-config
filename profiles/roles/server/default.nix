{ config, pkgs, ... }:

{
  imports = [
    # base profile
    ../base

    ../../../config/hardware/graphics.nix

    ../../../config/virtualization/libvirt.nix
    ../../../config/virtualization/podman.nix
    ../../../config/virtualization/virt-manager.nix
  ];

  services.cockpit = {
    enable = true;
    openFirewall = true;
    settings = {
      Session = {
        Banner = "/etc/issue.plaintext";
      };
    };  
  };
}