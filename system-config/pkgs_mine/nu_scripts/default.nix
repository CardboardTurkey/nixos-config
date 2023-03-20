{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-19";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "7c28a4f6c3c9910efe710f47e22cca6eec756c94";
    sha256 = "16dyyyd2v6nb77j63gmiky6xybc86crhqgiyiq6im8xvvkf7q3jw";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
