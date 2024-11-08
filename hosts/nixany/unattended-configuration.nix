{ config, pkgs, lib, ... }:
let
  rootPassword = builtins.hashString "sha256" (toString builtins.currentTime);

  timeHash = builtins.substring 0 8 (builtins.hashString "sha256" (toString builtins.currentTime));

  macAddress = pkgs.writeScriptBin "get-mac-address.sh" ''
    ${pkgs.iproute2}/bin/ip -o link | ${pkgs.gnugrep}/bin/grep ether | ${pkgs.gawk}/bin/awk "{ print $17 }" | ${pkgs.coreutils}/bin/head -n 1 | ${pkgs.coreutils}/bin/tr -d ':'
  '';

  preBuildScript = pkgs.writeScriptBin "pre-build-update.sh" ''
    echo "Updating Nix channels..."
    nix-channel --update
    echo "Channels updated successfully."
  '';
in
{
  # Run the pre-build script at activation time
  system.activationScripts.updateChannels = {
    text = ''
      ${preBuildScript}
    '';
  };

  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Set default hostname
  # networking.hostName = "nixany-${if (builtins.readFile macAddress) == "" then timeHash else (builtins.readFile macAddress)}";
  networking.hostName = "nixany-${timeHash}";

  # Bootloader
  boot.loader = {
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.useOSProber = true;
    # grub.splashImage = "/home/sysop/nix-bootloader.png";
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  environment.etc."issue" = {
    text = ''

       This is \l on \n.\o (\s \m \r)

       This system is for authorized users only. Individual use of this computer
       system and/or network without authority, or in excess of your authority,
       is strictly prohibited. Monitoring of transmissions or transactional
       information may be conducted to ensure the proper functioning and security
       of electronic communication resources. Anyone using this system expressly
       consents to such monitoring and is advised that if such monitoring reveals
       possible criminal activity or policy violation, system personnel may
       provide the evidence of such monitoring to law enforcement or to other
       senior officials for disciplinary action.


    '';
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs
    cryptsetup
    curl
    dosfstools
    disko
    e2fsprogs
    efibootmgr
    efitools
    efivar
    git
    gnugrep
    gparted
    grub2_efi
    gawk
    inotify-tools
    iproute2
    nixos-install-tools
    parted
    tmux
    vim
    util-linux
    wget
  ];

  console = {
    earlySetup = true;
    font = "ter-v32n";
    packages = [ pkgs.terminus_font ];
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  systemd.services.openssh = {
    enable = true;
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # enable systemd-networkd
  networking.useNetworkd = true;
  networking.useDHCP = true;
  systemd.network.enable = true;
  networking.dhcpcd.enable = false;
  networking.networkmanager.enable = false;

  systemd.network.networks."10-e" = {
    matchConfig.Name = "e*";
    networkConfig.DHCP = "ipv4";
  };

  users.users.root = {
    password = rootPassword;
  };

  users.users.sysop = {
    isNormalUser = true;
    initialPassword = "sysop";
    extraGroups = [ "wheel" ]; # Grants sudo access
  };

  security.sudo.wheelNeedsPassword = false;
  
  system.stateVersion = "24.05";
}
