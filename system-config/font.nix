{ pkgs, config, ... }:
{
  allowed_unfree = [ "joypixels" ];
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts.packages =
    (

      if (config.hostname == "Osprey") then
        with pkgs;
        [
          (nerdfonts.override {
            fonts = [
              "DejaVuSansMono"
              "JetBrainsMono"
            ];
          })
        ]
      else
        with pkgs.nerd-fonts;
        [
          dejavu-sans-mono
          jetbrains-mono
        ]
    )
    ++ (with pkgs; [
      hasklig
      # dejavu_fonts
      ttf_bitstream_vera
      joypixels
      font-awesome
      cantarell-fonts
      texlivePackages.alfaslabone # for rust manchester
      fira-sans # for rust manchester
    ]);
}
