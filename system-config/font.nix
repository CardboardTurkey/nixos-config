{ pkgs, ... }:
{
  allowed_unfree = [ "joypixels" ];
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts.packages = with pkgs; [
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.jetbrains-mono
    hasklig
    # dejavu_fonts
    ttf_bitstream_vera
    joypixels
    font-awesome
    cantarell-fonts
    texlivePackages.alfaslabone # for rust manchester
    fira-sans # for rust manchester
  ];
}
