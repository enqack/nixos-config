{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "nixos-black-snowflake-plymouth";
  version = "0.0.1";

  src = ./theme;

  buildInputs = [];

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/nixos-black-snowflake
    cp -r * $out/share/plymouth/themes/nixos-black-snowflake
  '';

  meta = with pkgs.lib; {
    description = "NixOS Black Snowflake Plymouth Theme.";
    license = licenses.bsd3;
    maintainers = [ maintainers.enqack ];
  };
}
