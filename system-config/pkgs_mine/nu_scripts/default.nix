{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-05-31";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "ab881a61d57cac0a35244d93c824f8880fb70db7";
    sha256 = "0bnm6y24v73q7yzyzc24gg7hnhln7in951v9bv238idylazirnhn";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
