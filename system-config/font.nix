{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" "Hasklig" ]; })
    noto-fonts-emoji
    font-awesome
  ];
}