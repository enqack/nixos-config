{config, lib, pkgs, ...}:

let
  cfg = config.host.application.zsh;
in
{
  options = {
    host.application.zsh = {
      enable = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = "Enables zsh";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zsh
    ];

    programs.zsh {
      enable = true;
      enableLsColors = true;
      enableCompletion = true;
      enableGlobalCompInit = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -alF";
        la = "ls -A";
        lt = "ls -ltr";
        l  = "ls -CF";

        df = "df -h";
        free = "free -h";
      };

      histSize = 100000;
      histFile = "~/.config/zsh/history";
    };

    environment.etc = {
      "zshenv.local" = { source = ./files/zsh/zshenv.local; };
      "zshrc.local" = { source = ./files/zsh/zshrc.local; };
    };        
  };
}
