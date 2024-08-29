{ pkgs, ... }: {
  allowed_unfree = [ "joypixels" ];
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" "JetBrainsMono" ]; })
    hasklig
    # dejavu_fonts
    ttf_bitstream_vera
    joypixels
    font-awesome
    cantarell-fonts
  ];
}
