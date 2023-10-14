{ lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "kiran";
      };
    };
  };
  programs.regreet = {
    enable = true;
    package = pkgs.greetd.regreet.overrideAttrs (self: super: rec {
      version = "unstable-10-10-2032";
      src = pkgs.fetchFromGitHub {
        owner = "rharish101";
        repo = "ReGreet";
        rev = "e787317f3ddf987389017b85e089ce5a23662b6e";
        hash = "sha256-yvQUGodhyuiXppwc8VmAIaKne4EWLXX7vEPV2zVhmSg=";
      };
      # cargoDeps = super.cargoDeps.overrideAttrs (_: {
      #   inherit src;
      #   outputHash = lib.fakeSha256;
      # });
    });

    settings = {
      background = {
        path = files/nix-wallpaper-stripes-logo.png;
        fit = "Cover";
      };
      # GTK = {
      #   cursor_theme_name = "Bibata-Modern-Classic";
      #   font_name = "Lexend 9";
      #   icon_theme_name = "Papirus-Dark";
      #   theme_name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      # };
    };
  };
}
