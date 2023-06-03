{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-06-02";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "b92eb7c03f8014c7d8ffac33ad89343474818321";
    sha256 = "17x2660p0cnx7b3af0nfnp64al3sbw7lzpcfkwj05m632hsqi7sn";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
