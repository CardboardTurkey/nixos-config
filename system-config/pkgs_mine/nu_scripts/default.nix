{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-05";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "09f6d2a4733933f394d30b41dd8f042918c6fa87";
    sha256 = "0b1rxah8r2zkgg4afcyfsg64i225dn15p2qvj4ahr3zk87ydv1kb";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
