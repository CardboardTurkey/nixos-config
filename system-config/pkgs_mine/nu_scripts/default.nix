{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-23";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "9e62390ec14c96d1e98799f6669dfb3634d06aaf";
    sha256 = "1vrym1spw71ba5yza8z5s5dmsnfqi8dcxh9jj7k28gaxqq41albn";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
