{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-15";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "2024d52938db0e8e4e5c444f504a471179b90200";
    sha256 = "1pg3zkw3ywdffyasd1kxzgrbcbhi95b5nl3ipqwp5dh68l93b4ly";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
