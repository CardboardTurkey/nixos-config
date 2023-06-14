{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-12";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "424e8d61a58563c3d6f7cec5e816924dbf69faa1";
    sha256 = "03ijzk8b5wcwa8ama0l5vi20n3ldx54lkaydwimfjnspgm54ygid";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
