{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-09";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "039930b4e45003c167cad3f0e2567e57510a6a47";
    sha256 = "0sl3xi15b09lbn4sj2zd4ayyvhaq1703r2almrpwag5a68fkj3f0";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
