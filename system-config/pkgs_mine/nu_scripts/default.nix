{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-21";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "1884426d7914fc3be41da12402057bbf6235883d";
    sha256 = "0m5hlajcdsqz9jrk27a83ks8m96b8p8kq2r3j65q91z7l8psl7nh";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
