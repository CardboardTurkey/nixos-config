{ pkgs, osConfig, lib, ... }:
let
  palette = (lib.importJSON
    "${osConfig.catppuccin.sources.palette}/palette.json").${osConfig.catppuccin.flavor}.colors;
  eww = pkgs.runCommandLocal "brudda-ewwwww"
    (builtins.mapAttrs (_: colour: colour.hex) palette) ''
      mkdir $out
      cp -r ${./config}/* $out
      substituteAllInPlace $out/eww.scss
    '';
in {
  home.packages = with pkgs; [ material-icons linearicons-free ];
  fonts.fontconfig.enable = true;
  programs.eww = {
    enable = true;
    configDir = eww;
  };
}
