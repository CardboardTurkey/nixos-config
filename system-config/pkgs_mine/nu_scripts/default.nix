{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-21";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "2d367e4137855b7a1088a575cd1299a9050fb215";
    sha256 = "0snkhqs0jpfbm7b1w0ynyvzr6pi765dwjg1hvw85lgrmzzzlcxsz";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
