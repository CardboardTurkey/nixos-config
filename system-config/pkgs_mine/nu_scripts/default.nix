{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-05";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "bc71f8d1e9f59c8911682a2abb15ef376bc699f8";
    sha256 = "01xkw2npr7ixa7z6by0sz3h6vybb9daxgcd8z5r990znnj7lrsr0";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
