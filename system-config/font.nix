{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    hasklig
    # dejavu_fonts
    ttf_bitstream_vera
    noto-fonts-emoji
    font-awesome
  ];
}
