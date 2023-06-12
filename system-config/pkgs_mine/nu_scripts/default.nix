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
    rev = "2e46f056c647803fb3fece3e1f00349e1f5cb1f0";
    sha256 = "0s9vfr962rbdli6h1rgcvfdd1yv57njwmwd068vr9dah9r2g1y8y";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
