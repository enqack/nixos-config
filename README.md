# NixOS and Nix-Darwin Configuration

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
    │  ├── roles
    │  └── software
    ├── hardware
    │  └── vm-guest
    ├── linux
    │  ├── roles
    │  └── software
    └── shared
        └── software
            ├── nix-extra
            ├── python
            ├── steam
            └── vim
```
