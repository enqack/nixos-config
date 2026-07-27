{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.applications.tailscale;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  options.modules.applications.tailscale = {
    enable = mkEnableOption "Tailscale";

    authKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to a file holding the auth key. Never put the key itself in nix store paths.";
    };

    extraUpFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    routingFeatures = mkOption {
      type = types.enum [ "none" "client" "server" "both" ];
      default = "none";
      description = "Linux only. Ignored on Darwin - there is no equivalent.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.tailscale.enable = true;
      services.tailscale.package = pkgs.tailscale;
    }

    (mkIf (!isDarwin) {
      services.tailscale.useRoutingFeatures = cfg.routingFeatures;
      services.tailscale.authKeyFile = cfg.authKeyFile;
      services.tailscale.extraUpFlags = cfg.extraUpFlags;
      services.tailscale.openFirewall = true;
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
    })

    (mkIf isDarwin {
      #services.tailscale.overrideLocalDns = true;

      # darwin module has no authKeyFile/extraUpFlags equivalent
      # emulate it imperatively at activation time
      system.activationScripts.postActivation.text = mkAfter ''
        if [ -n "${optionalString (cfg.authKeyFile != null) "x"}" ]; then
          ${pkgs.tailscale}/bin/tailscale up \
            --authkey "$(cat ${toString cfg.authKeyFile})" \
            ${concatStringsSep " " cfg.extraUpFlags} || true
        fi
      '';
    })
  ]);
}

