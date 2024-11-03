{ config, lib, pkgs, ... }:

{
  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    promptInit = builtins.readFile ./global-zsh-config.zsh;
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      lt = "ls -ltr";
      l  = "ls -CF";

      edit-system = "sudo vim /etc/nixos/hosts/$(hostname)/configuration.nix";
      edit-home   = "vim ~/.config/home-manager/home.nix";
      rebuild-system = "sudo nixos-rebuild switch --flake $(readlink -f /etc/nixos)#$(hostname)";
      rebuild-home   = "home-manager switch --flake ~/.config/home-manager";
    };
  };

  # Environment
  environment.shells = with pkgs; [ zsh bash ];

  environment.etc."zshenv.local".text = builtins.readFile ./global-zsh-env.zsh;

  environment.etc."zprofile.local".text = builtins.readFile ./global-zsh-profile.zsh;

  environment.variables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };
}
