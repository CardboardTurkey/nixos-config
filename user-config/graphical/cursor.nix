{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  capitalise = word: lib.toUpper (lib.substring 0 1 word) + lib.substring 1 (-1) word;
in
{
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors."${osConfig.flavour}${capitalise osConfig.accent}";
    name = "catppuccin-${osConfig.flavour}-${osConfig.accent}-cursors";
    gtk.enable = true;
    hyprcursor.enable = true;
    x11.enable = true;
  };
}
