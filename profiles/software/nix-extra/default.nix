{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    deadnix
    graphviz # for nix-du
    nix-diff
    nix-du
    nix-health
    nix-init
    nix-melt
    nix-output-monitor
    nix-prefetch
    nix-prefetch-git
    nix-search
    inputs.nix-search-tv.packages.${pkgs.system}.default
    nix-top
    nix-tree
    nixd
    nixfmt-rfc-style
    nvd
    nurl
    manix 
    statix
  ];
}
