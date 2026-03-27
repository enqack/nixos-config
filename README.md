# NixOS and Nix-Darwin Configuration

## Getting started

### Linux

Install and initial run:

1. `git clone git@github.com:enqack/nixos-config.git /home/<user>/.config/nixos`
2. `sudo ln -s /home/<user>/.config/nixos /etc/nixos`
3. `nixos-rebuild switch $(readlink -f /etc/nixos)`

Subsequent runs:

- `nh os switch $(readlink -f /etc/nixos)`

### Darwin

Install and initial run:

1. `git@github.com:enqack/nixos-config.git /Users/<user>/.config/nix-darwin`
2. `sudo ln -s /Users/<user>/.config/nix-darwin /etc/nix-darwin`
3. `darwin-rebuild switch $(readlink -f /etc/nix-darwin)`

Subsequent runs:

- `nh darwin switch $(readlink -f /etc/nixos)`

## Current directory structure

```text
nixos-config
├── hosts                         # Host configurations
├── modules                       # Configuration modules
│  ├── darwin                     # MacOS configuration modules
│  ├── linux                      # Linux configuration modules
│  └── shared                     # OS agnostic configuration modules
├── overlays                      # Package overlays
├── pkgs                          # Package definitions
└── profiles                      # Configuration profiles
    ├── darwin
    │  ├── roles                  # System roles profiles (desktop, laptop)
    │  └── software               # Software profiles
    ├── hardware                  # Hardware profiles
    │  └── vm-guest
    ├── linux
    │  ├── roles
    │  └── software
    └── shared
        └── software
```
