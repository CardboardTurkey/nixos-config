{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-04-03";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "d7cdfdba4eb9b8bf7c6ed8adcd056d078dd19688";
    sha256 = "0bw97sall13bic8iq9f10d3vrawgvjmpaqcr6vq9r0ixjd90kcab";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
