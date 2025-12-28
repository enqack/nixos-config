{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python313
    python313Packages.numpy
    python313Packages.pandas
    python313Packages.matplotlib
  ];
}
