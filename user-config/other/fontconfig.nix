let
  ubraille_ttf = builtins.fetchurl {
    url = "https://yudit.org/download/fonts/UBraille/UBraille.ttf";
    sha256 = "sha256:08p1zzrjir244ak84659fj05lsf1wqc61519wz7jj2lj6lzw3pjb";
  };
in {
  home-manager.users.kiran = { pkgs, ... }: {
    xdg.configFile."fontconfig/fonts.conf".source =
      ../files/fontconfig/fonts.conf;
    home.file.".local/share/fonts/UBraille.ttf".source = "${ubraille_ttf}";
  };
}
