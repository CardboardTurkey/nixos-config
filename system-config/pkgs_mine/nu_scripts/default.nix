{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-15";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "0ca38a46f5fb3f1f20dd217c42a05be456d5b2d1";
    sha256 = "0ans1kdz3jn4awasdsdznd20dpjjz2rhvkfmrfiikm1vxpcy90zr";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
