{ stdenv, lib, ... }:

stdenv.mkDerivation {
  name = "home-manager-skeleton";
  version = "0.0.1";

  src = ./skeleton;

  installPhase = ''
    mkdir -p "$out"
    cp -r $src/* "$out/" || echo "Error: failed to copy files from $src to $out"
  '';

  meta = with lib; {
    description = "Home Manager skeleton package";
    version = "0.0.1";
    license = licenses.bsd3;
    maintainers = [ maintainers.enqack ];
  };
}

