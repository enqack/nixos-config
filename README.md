# NixOS Configuration

## Current directory structure

```

```

## Example directory structure

```
/etc/nixos/
├── flake.nix                    # Main entry for flakes-based configuration
├── configuration.nix            # Main configuration file (typically imports modules/*.nix)
├── hardware-configuration.nix   # Auto-generated hardware configuration
├── hosts/                        # Directory for per-host configurations
│   ├── hostname1.nix
│   └── hostname2.nix
├── modules/                      # Custom NixOS modules for services, applications, etc.
│   ├── networking.nix
│   ├── shells.nix
│   ├── zsh.nix
│   ├── databases/
│   │   ├── postgres.nix
│   │   └── mysql.nix
│   ├── services/
│   │   ├── web-server.nix
│   │   └── ssh.nix
│   └── users/
│       ├── default-user.nix
│       └── custom-user.nix
├── secrets/                      # Encrypted secrets or separate configuration files for secrets
│   ├── ssh-keys.nix
│   └── database-credentials.nix
├── profiles/                     # Custom profiles for specialized environments (e.g., dev, server)
│   ├── desktop.nix
│   ├── server.nix
│   └── minimal.nix
├── overlays/                     # Nixpkgs overlays for custom packages and patches
│   ├── custom-packages.nix
│   └── patches.nix
└── home-manager/                 # Home Manager configs for user-specific settings
    ├── flake.nix
    ├── home.nix
    └── users/
        ├── user1.nix
        └── user2.nix
```
