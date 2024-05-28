{ pkgs, stdenv, ... }:
stdenv.mkDerivation {
  pname = "pyup";
  version = "0.0.1";

  src = ./src;

  buildInputs = [ ];

  configurePhase = "";

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/share $out/bin
    mv shell.nix gitlab-ci.yml $out/share
    substituteAllInPlace pyup
    chmod +x pyup
    mv pyup $out/bin
  '';
}
