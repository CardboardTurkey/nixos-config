{ pkgs, osConfig, ... }:
let
  eww = pkgs.runCommandLocal "brudda-ewwwww"
    (builtins.mapAttrs (_: colour: colour.hex) osConfig.theme) ''
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
