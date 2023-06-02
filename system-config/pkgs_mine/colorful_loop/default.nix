{ stdenv, fetchgit, ... }:

stdenv.mkDerivation rec {
  name = "colorful_loop";
  version = "unstable-2023-06-02";

  src = fetchgit {
    url = "https://gitlab.com/CardboardTurkey/plymouth-theme.git";
    rev = "7b8b845d4e870353042e0eee8374c8b0fbe84fe3";
    sha256 = "0r6nm806n5arckhvvhn5r3c6ccnm7hfydkwz03ibznbjjmq54g2k";
  };

  buildInputs = [ stdenv ];

  configurePhase = ''
    install_path=$out/share/plymouth/themes
    mkdir -p $install_path
  '';

  installPhase = ''
    cp -r colorful_loop $install_path
  '';

  meta = with stdenv.lib; { platfotms = platforms.linux; };
}
