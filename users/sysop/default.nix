{ config, pkgs, ...}:

let

dataHome = config.xdg.dataHome;
configHome = config.xdg.configHome;
cacheHome = config.xdg.cacheHome;
runtimeDir = config.xdg.runtimeDir;

in rec {
  imports = [ ../common ];  

  home.username = "sysop";
  home.homeDirectory = "/home/sysop";

  xdg.enable = true;

  home.packages = with pkgs; [
    neofetch
    lf
  ];

  # Create symlink for .zshenv in home directory
  #home.file.".zshenv".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/zsh/.zshenv";

  home.stateVersion = "23.11";

  # Let home manager install and manage itself.
  programs.home-manager.enable = true;
}
