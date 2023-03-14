{ lib
, stdenv
, pkgs
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nu_scripts";
  version = "unstable-2023-03-12";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "34235efe5fad15021c330a7f25e12b1383626e25";
    sha256 = "1v9hy107dvf500xfyxbfav2kcbyzv6w229g6cicnkgwfcd5vyf9f";
  };

  installPhase = ''
    mkdir -p $out/share/nu_scripts
    mv ./* $out/share/nu_scripts
  '';
}
