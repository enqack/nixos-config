{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = "ctpv";
    rev = "master"; # Specify a specific commit hash or branch if required
    sha256 = "1vh5wl8swzd82fnsrwcb9bphfflcj140frhd086mpmmj8w4mfl5l"; # Replace with actual SHA-256
  };

  # Define dependencies if needed; adjust based on ctpv's requirements
  buildInputs = with pkgs; [ gnumake gcc file openssl ];

  # Configure and build the project
  buildPhase = ''
    make
  '';

  # Install the resulting binary and other files
  installPhase = ''
    mkdir -p $out/bin
    cp ctpv $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "CTPV: A project by Nikita Ivanov for visualizing control flow";
    license = licenses.mit; # Adjust based on the actual license
    maintainers = with maintainers; [ nikitaivanov ];
    homepage = "https://github.com/NikitaIvanovV/ctpv";
  };
}

