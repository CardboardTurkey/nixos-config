#with import <nixpkgs> {};
{ stdenv, pkgs, ... } :
stdenv.mkDerivation {
  pname = "scripts";
  version = "0.0.1";

  src = ./src;


  buildInputs = [
  ];

  configurePhase = ''
  '';

  buildPhase = ''
  '';

  installPhase = ''
    ls
    mkdir -p $out/bin
    mv ./* $out/bin
  '';
}
