{ lib 
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "fa5f262a5c9f674ab20fbedb3f002cbfb932420e";
    sha256 = "sha256-SUmVOO/JSVWU4xWpBgoq52xtMu81FEm54bbKsIzesg0=";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
