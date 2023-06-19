{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-17";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "c544a92a4015ce0ae5b3e31b51bcbedcbd0b1d9a";
    sha256 = "0is2n9ran6xf3rlm6wydwhka43927x91166nrcdcv2zmikmgqkhw";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
