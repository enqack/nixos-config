{ config, lib, pkgs, ... }:
let
  cfg = config.modules.base.users;

  # Your base user catalog (can grow over time).
  userCatalog = {
    sysadm = {
      description = "System Administrator";
      extraGroups = [ "wheel" "dialout" "libvirtd" "video" "render" ];
      initialPassword = "sysadm";
    };

    sysop = {
      description = "System Operator";
      extraGroups = [ "sudo" "dialout" "libvirtd" "video" "render" ];
      initialPassword = "sysop";
    };
  };

  # Defaults applied to every host if module is enabled.
  defaultUsers = [ "sysadm" "sysop" ];

  # Helper: merge groups intelligently.
  orEmpty = x: if x == null then [] else x;

  mergeGroups = base: overrides:
    lib.unique ((orEmpty base) ++ (orEmpty overrides));
  
  # Build one user definition from catalog + overrides.
  mkUser = name: overrides:
    let
      base =
        userCatalog.${name}
          or (throw "Unknown user '${name}' (not in userCatalog)");
    in
      {
        isNormalUser = true;
        shell = pkgs.zsh;
      }
      // base
      // overrides
      // {
        extraGroups = mergeGroups (base.extraGroups or []) (overrides.extraGroups or []);
      };

  # Expand default users into attrset { sysadm = {}; sysop = {}; }
  defaultUserAttrset =
    lib.genAttrs defaultUsers (_: {});

  # Merge:
  #  1) defaults (sysadm/sysop)
  #  2) extraUsers from host config
  #  3) userOverrides from host config
  #
  # (Note: overrides should win, but groups get merged via mkUser)
  selectedUsers =
    (defaultUserAttrset // cfg.extraUsers);

  overriddenUsers =
    lib.mapAttrs (name: u:
      mkUser name (u // (cfg.userOverrides.${name} or {}))
    ) selectedUsers;

  # Remove any users explicitly disabled at host level.
  finalUsers =
    lib.filterAttrs (name: _: !(lib.elem name cfg.disableUsers)) overriddenUsers;

  # Collect all group names used by finalUsers.
  groupsUsed =
    lib.unique (lib.flatten (map (u: u.extraGroups or []) (lib.attrValues finalUsers)));

  renderedGroups =
    lib.genAttrs groupsUsed (_: {});
in
{
  options.modules.base.users = {
    enable = lib.mkEnableOption "base users configuration";

    # Host adds users here.
    extraUsers = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
      description = "Additional users to create on this host (in addition to defaults).";
    };

    # Host can override any user (default or extra) here.
    userOverrides = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
      description = "Per-user overrides for users on this host.";
    };

    # Host can disable default users (or any user) here.
    disableUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users to NOT create on this host (removes defaults if listed).";
    };

    sudoGroup = lib.mkOption {
      type = lib.types.str;
      default = "sudo";
    };
  };

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    users.groups =
      renderedGroups // {
        ${cfg.sudoGroup} = {};
      };

    users.users =
      finalUsers // {
        root = {
          initialHashedPassword = builtins.hashString "sha256" "none";
        };
      };

    security.sudo = {
      wheelNeedsPassword = false;
      extraRules = [
        { groups = [ cfg.sudoGroup ]; commands = [ "ALL" ]; }
      ];
    };
  };
}
