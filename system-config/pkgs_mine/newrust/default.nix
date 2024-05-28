{ pkgs, stdenv, ... }:
stdenv.mkDerivation {
  pname = "newrust";
  version = "0.0.1";

  src = ./src;

  buildInputs = [ ];

  configurePhase = "";

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/share $out/bin

    mv main.rs lib.rs cli.rs flake.nix gitlab-ci.yml $out/share

    cargo=${pkgs.cargo}/bin/cargo substituteAllInPlace newrust
    chmod +x newrust
    mv newrust $out/bin
  '';
}
