{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" "Hasklig" ]; })
    noto-fonts-emoji
    font-awesome
  ];
}
