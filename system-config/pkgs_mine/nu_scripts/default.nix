{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-05-24";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "a7bde3acf20ed633da87f60fe4b9b4ea515f59d7";
    sha256 = "0zkz03mc3sf75dzxpnifj0r5ycq7miwqbrirxknff1rsp9rfgdnq";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
