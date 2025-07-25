{ pkgs, ... }:
{
  fonts = {
    packages =
      (with pkgs.nerd-fonts; [
        dejavu-sans-mono
        jetbrains-mono
      ])
      ++ (with pkgs; [
        hasklig
        # dejavu_fonts
        ttf_bitstream_vera
        font-awesome
        noto-fonts-color-emoji
        cantarell-fonts
        texlivePackages.alfaslabone # for rust manchester
        fira-sans # for rust manchester
        ipafont # for japanese
      ]);
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        # Just mash them all in and see what happens
        monospace = [
          "Font Awesome 6 Free,Font Awesome 6 Free Regular"
          "Font Awesome 6 Free,Font Awesome 6 Free Solid"
          "Font Awesome 6 Brands,Font Awesome 6 Brands Regular"
          "JetBrainsMono Nerd Font"
        ];
        sansSerif = [
          "Font Awesome 6 Free,Font Awesome 6 Free Regular"
          "Font Awesome 6 Free,Font Awesome 6 Free Solid"
          "Font Awesome 6 Brands,Font Awesome 6 Brands Regular"
          "Bitstream Vera Sans"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
