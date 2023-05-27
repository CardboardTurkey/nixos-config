{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-05-26";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "80e9d07d80fc326280b555e730f2ee516deaef32";
    sha256 = "01l1v6vnqmbn62j8halifndl20ynpnhy8xw3ikg8f1qwwvrgdnqi";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
