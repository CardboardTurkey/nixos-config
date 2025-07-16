{ pkgs, osConfig, ... }:
{
  # home.packages = [ pkgs.atool pkgs.httpie ];
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.zafiro-icons;
      name = "Zafiro-icons-Dark";
    };
    theme = {
      name = "Colloid-Teal-Dark-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        tweaks = [ "catppuccin" ];
        themeVariants = [ "teal" ];
      };
    };
    font = {
      name = "Bitstream Vera Sans ${builtins.toString osConfig.fontSizeSmall}";
    };
  };
}
