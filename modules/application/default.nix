{ lib, ... }:

{
  lib.imports = [
    ./rsync.nix
    ./zsh
  ];
}
