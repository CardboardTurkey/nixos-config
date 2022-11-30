{ pkgs, stdenv, ... } :
stdenv.mkDerivation {
  pname = "rustup";
  version = "0.0.1";

  src = ./src;

  buildInputs = [
  ];

  configurePhase = ''
  '';

  buildPhase = ''
  '';

  installPhase = ''
    mkdir -p $out/share $out/bin

    mv main.rs lib.rs cli.rs bin_deps.txt lib_deps.txt shell.nix gitlab-ci.yml $out/share

    cargo=${pkgs.cargo}/bin/cargo substituteAllInPlace rustup
    chmod +x rustup
    mv rustup $out/bin
  '';
}
