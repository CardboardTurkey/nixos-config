{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-23";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "d984ff61aa9f9c4bc3e6d1c60f7e074365f6aab9";
    sha256 = "0ccq07rivxsbvg5xjxg6p4cq4n0hm8hj2xayxi80sf7czsw1cha0";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
