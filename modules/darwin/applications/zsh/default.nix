{
  config,
  pkgs,
  lib,
  ...
}:

let
  zshPluginScript = pkgs.writeShellScript "zsh-plugins" ''
      # Open new shell in same directory
      [[ -d $PWD ]] || cd $HOME

      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh

      # Zplug setup
      export ZPLUG_HOME=$HOME/.zplug
      source ${pkgs.zplug}/share/zplug/init.zsh

      zplug "zsh-users/zsh-autosuggestions"
      zplug "zsh-users/zsh-completions"
      zplug "plugins/git", from:oh-my-zsh
      zplug "plugins/sudo", from:oh-my-zsh
      zplug "plugins/tig", from:oh-my-zsh
      zplug "plugins/kubectl", from:oh-my-zsh
      zplug "plugins/fzf", from:oh-my-zsh
      zplug "plugins/rust", from:oh-my-zsh

      # Install plugins if currently missing
      if ! zplug check --verbose; then
          printf "Install? [y/N]: "
          if read -q; then
              echo; zplug install
          fi
      fi
      zplug load
  '';
in

{
  options.modules.applications.zsh = {
    enable = lib.mkOption {
      description = "Configure darwin system-wide zsh";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf config.modules.applications.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      enableAutosuggestions = true;
      enableFastSyntaxHighlighting = true;
    };

    # Environment
    environment.shells = with pkgs; [
      zsh
      bash
    ];

    environment.etc."zshrc.local".text = builtins.readFile ./global-zsh-config.zsh;

    environment.etc."zshplugins.local".text = builtins.readFile zshPluginScript;

    environment.etc."zshenv.local".text = builtins.readFile ./global-zsh-env.zsh;

    environment.etc."zprofile.local".text = builtins.readFile ./global-zsh-profile.zsh;

    environment.variables = {
      ZDOTDIR = "$HOME/.config/zsh";
    };

    # programs.starship = {
    #   enable = true;
    #   settings = {
    #     add_newline = false;

    #     # These two are the big knobs for responsiveness.
    #     command_timeout = 750; # ms; kill slow modules
    #     scan_timeout = 30; # ms; filesystem scanning

    #     format = ''
    #       [\[](bold red)$env_var[\]](bold red)[\[](bold red)$username[@](bold green)$hostname $directory[\]](bold red) $git_branch$git_status$git_commit$git_state$nix_shell$direnv$docker_context$container$python$nodejs$rust$golang$java$dotnet$lua$zig$jobs$battery
    #       ${"$"}{custom.status} $character
    #     '';

    #     custom = {
    #       status = {
    #         command = "echo $PROMPT_STATUS_STRING";
    #         when = "test -n \"$PROMPT_STATUS_STRING\"";
    #         format = "$output";
    #         style = "";
    #       };
    #     };

    #     # --- Core identity/context ---
    #     time = {
    #       disabled = false;
    #       format = "[$time]($style)";
    #       time_format = "%Y-%m-%d %H:%M:%S";
    #       style = "bold green";
    #     };

    #     username = {
    #       show_always = true;
    #       format = "[$user]($style)";
    #       style_user = "bold yellow";
    #       style_root = "bold red"; # root stands out
    #     };

    #     hostname = {
    #       ssh_only = false;
    #       format = "[$hostname]($style)";
    #       style = "bold blue";
    #     };

    #     directory = {
    #       format = "[$path]($style)";
    #       style = "bold magenta";
    #       truncation_length = 0; # keep it readable when deep
    #       truncate_to_repo = false; # repo root anchors the path
    #       read_only = " ";
    #       read_only_style = "bold red";
    #     };

    #     # --- Status / duration ---
    #     status = {
    #       disabled = false;
    #       format = "[$status]($style)";
    #       style = "bold red";
    #       success_symbol = "0";
    #       map_symbol = false;
    #     };

    #     cmd_duration = {
    #       disabled = false;
    #       show_milliseconds = true;
    #       min_time = 0;
    #       show_notifications = true;
    #       format = "[$duration]($style)";
    #       style = "bold cyan";
    #     };

    #     env_var = {
    #       disabled = false;
    #       variable = "PROMPT_TIME";
    #       format = "[$env_value]($style)";
    #       style = "bold green";
    #       default = "0000-00-00 00:00:00";
    #     };

    #     character = {
    #       success_symbol = "[>](bold red)";
    #       error_symbol = "[>](bold red)";
    #       vimcmd_symbol = "[<](bold green)";
    #       vimcmd_visual_symbol = "[<](bold yellow)";
    #       vimcmd_replace_symbol = "[<](bold purple)";
    #     };

    #     # --- Git: enable, but keep it fast ---
    #     git_branch = {
    #       disabled = false;
    #       format = " [$symbol$branch]($style)";
    #       symbol = " ";
    #       style = "bold purple";
    #     };

    #     git_status = {
    #       disabled = false;
    #       # This is the most expensive module. Keep it concise.
    #       format = "([ \\[$all_status$ahead_behind\\] ]($style))";
    #       style = "bold red";
    #       stashed = "≡";
    #       ahead = "⇡";
    #       behind = "⇣";
    #       diverged = "⇕";
    #       modified = "!";
    #       staged = "+";
    #       untracked = "?";
    #       renamed = "»";
    #       deleted = "✘";
    #       conflicted = "=";
    #     };

    #     git_commit = {
    #       disabled = false;
    #       commit_hash_length = 7;
    #       format = " [(\\($hash\\))]($style)";
    #       style = "bold green";
    #     };

    #     git_state = {
    #       disabled = false;
    #       format = " [\\($state( $progress_current/$progress_total)\\)]($style)";
    #       style = "bold yellow";
    #     };

    #     git_metrics = {
    #       disabled = true; # turn on if you want, but it adds cost
    #     };

    #     # --- Nix / env ---
    #     nix_shell = {
    #       disabled = false;
    #       format = " via [$symbol$state( \\($name\\))]($style)";
    #       symbol = "❄️  ";
    #       style = "bold blue";
    #     };

    #     direnv = {
    #       disabled = false;
    #       format = " [$symbol$loaded/$allowed]($style)";
    #       symbol = "direnv ";
    #       style = "bold bright-yellow";
    #     };

    #     # --- Containers / cloud ---
    #     docker_context = {
    #       disabled = false;
    #       format = " via [$symbol$context]($style)";
    #       symbol = "🐳 ";
    #       style = "blue bold";
    #       only_with_files = true;
    #     };

    #     kubernetes = {
    #       disabled = true; # flip to false if you actually use it
    #       format = " on [$symbol$context( \\($namespace\\))]($style)";
    #       symbol = "☸ ";
    #       style = "cyan bold";
    #     };

    #     aws.disabled = true;
    #     gcloud.disabled = true;
    #     azure.disabled = true;
    #     openstack.disabled = true;

    #     # --- Languages: enable, but avoid unnecessary scans ---
    #     python = {
    #       disabled = false;
    #       format = " via [${"$"}symbol${"$"}version( \\($virtualenv\\))]($style)";
    #       symbol = "🐍 ";
    #       style = "yellow bold";
    #     };

    #     golang = {
    #       disabled = false;
    #       format = " via [$symbol($version)]($style)";
    #       symbol = "🐹 ";
    #       style = "bold cyan";
    #     };

    #     rust = {
    #       disabled = false;
    #       format = " via [$symbol($version)]($style)";
    #       symbol = "🦀 ";
    #       style = "bold red";
    #     };

    #     nodejs = {
    #       disabled = false;
    #       format = " via [$symbol($version)]($style)";
    #       symbol = " ";
    #       style = "bold green";
    #     };

    #     java.disabled = false;
    #     dotnet.disabled = false;
    #     lua.disabled = false;
    #     zig.disabled = false;
    #     nim.disabled = false;
    #     ocaml.disabled = true; # set to false if you use it
    #     haskell.disabled = true; # same
    #     perl.disabled = true; # same
    #     ruby.disabled = true; # same

    #     sudo = {
    #       disabled = false;
    #       format = " [as $symbol]($style)";
    #     };

    #     jobs = {
    #       disabled = false;
    #       format = " [$symbol$number]($style)";
    #       symbol = "✦";
    #       style = "bold blue";
    #     };

    #     battery.disabled = true; # enable if you’re on laptop
    #     memory_usage.disabled = true;

    #     # Reduce churn / surprises:
    #     follow_symlinks = true;
    #   };
    # };

    environment.systemPackages = with pkgs; [
      nix-zsh-completions
      zsh-forgit
      zsh-fzf-tab
      zsh-nix-shell
      zplug
    ];
  };
}
