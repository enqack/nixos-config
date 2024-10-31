{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "nixos-blur-plymouth";
  version = "0.0.1";

  src = pkgs.fetchgit {
    url = "https://git.gurkan.in/gurkan/nixos-blur-plymouth.git";
    rev = "ea75b51a1f"; # Replace with the exact revision you want
    sha256 = "sha256-BSmh+Gy3yJMA4RoJ0uaQ/WsYBs+Txr6K3cAQjf+yM5Y="; # Verify if needed
  };

  # Dependencies
  buildInputs = [];

  # Configure phase to create the theme directory
  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  # Install phase to copy the theme files
  installPhase = ''
    cp -r nixos-blur $out/share/plymouth/themes/
    sed "s@/usr/@$out/@" nixos-blur/nixos-blur.plymouth > $out/share/plymouth/themes/nixos-blur/nixos-blur.plymouth
  '';

  # Metadata for the package
  meta = with pkgs.lib; {
    description = "NixOS Blur Plymouth Theme";
    license = licenses.gpl3;
    maintainers = with maintainers; [ enqack ];
  };
}

