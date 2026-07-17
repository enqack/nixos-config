{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python314
    python314Packages.numpy
    python314Packages.pandas
    python314Packages.matplotlib
  ];
}
