{ stdenv, fetchgit, ... }:

stdenv.mkDerivation rec {
  name = "colorful_loop";
  version = "unstable-2023-06-03";

  src = fetchgit {
    url = "https://gitlab.com/CardboardTurkey/plymouth-theme.git";
    rev = "d45906180a9f7ef9d37c990b9f45b3c325117872";
    sha256 = "16jpnlfqxhm6mz8hpg3rsasgaq75jhc8vix6insqvq17n7wxh80y";
  };

  buildInputs = [ stdenv ];

  configurePhase = ''
    install_path=$out/share/plymouth/themes
    mkdir -p $install_path
  '';

  installPhase = ''
    cp -r colorful_loop $install_path
  '';

  meta = with stdenv.lib; {
    platfotms = platforms.linux;
  };
}
