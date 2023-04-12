{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "5f463775f51d2c74b7d26dabd85ae6ac4cb2741a";
    sha256 = "072d5rh314h66qxw9z6v4nmcr5zv13dq7i619g2c2lw3cdg6fcjz";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
