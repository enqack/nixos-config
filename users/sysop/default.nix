{ config, lib, pkgs, ...}:

let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

dataHome = config.xdg.dataHome;
configHome = config.xdg.configHome;
cacheHome = config.xdg.cacheHome;
runtimeDir = config.xdg.runtimeDir;

in {
  options = {
    host.user.sysop = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enable the sysop user";
      };
    };
  };
 

  config = lib.mkIf config.host.user.sysop.enable {
    users.users.sysop = {
      isNormalUser = true;
      description = "sysop";
      group = "users";
      extraGroups = [
        "wheel"
      ] ++ ifTheyExist [
        "video"
        "audio"
        "docker"
        "git"
        "libvirtd"
      ];
      
      # openssh.authorizedKeys.key = [ (builtin.readFile ./ssh.pub) ];
      # hashedPasswordFile = mkDefault config.sops.secrets.sysop-password.path;
    };
    # create ~/.config/home-manger/flake.nix
  };   
}
