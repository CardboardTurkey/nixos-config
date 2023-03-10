{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-08";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "2f142406d3612dc5766f1220b3d127366e6d5a92";
    sha256 = "1danms1q7ir83d6hyw081d3ydxpbb0d5i91jd3269b4raz8isr1l";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
