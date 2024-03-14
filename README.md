# NixOS Configurations

## Tree Structure

- `flake.nix`: Entrypoint for NixOS configurations.
- `hosts`: Host Configurations
  - `common`: Shared configurations consumed by all hosts.
    - `secrets`: Secrets that are available to all users
  - `<host_a>`: "host_a" specific hardware and host configuration
    - `secrets`: Secrets that are specific to the 'host_a' host
  - `...`: And so on as above with other hosts
- `lib`: Helpers, functions, libraries and timesavers
- `modules`: Modules that are specific to this implementation and allow for toggled configuration
  - `application`: Applications accessible to all users of system
  - `container`: Containers using some sort of OCI container engine
  - `features`: Features such as virtualization, gaming, cross compilation
  - `filesystem`: Encryption, impermanence, BTRFS options
  - `hardware`: Bluetooth, Printing, Sound, Wireless
  - `network`: Firewalls and VPNs
  - `service`: Miscellanious daemons
  - `roles`: Machine roles ie. laptop or server
- `overlays`: Ammendments and updates to packages that exist in the nix ecosphere
- `packages`: Custom packages, services, scripts that are specific to this installation
- `users`: Individual User folders

## Resources

Basis for directory tree of this nixos-config repo: [tiredofit/nixos-config](https://github.com/tiredofit/nixos-config.git)

