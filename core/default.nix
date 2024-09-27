{ lib, config, ... }:

with lib;
with types; {
  imports = [ ./nord.nix ./keys.nix ./catppuccin.nix ];

  options = {
    hostname = mkOption {
      default = "";
      type = uniq str;
      description = "Network hostname";
    };
    font_size_small = mkOption {
      default = 12.0;
      type = float;
      description = "Small font size";
    };
    font_size_medium = mkOption {
      default = 15.0;
      type = float;
      description = "Medium font size";
    };
    font_size_large = mkOption {
      default = 19.0;
      type = float;
      description = "Large font size";
    };
    allowed_unfree = mkOption {
      default = [ ];
      type = listOf str;
      description = "Allowed unfree packages";
    };
    wallpapers = mkOption {
      default = {
        single = builtins.fetchurl
          "https://images.pexels.com/photos/27168244/pexels-photo-27168244.jpeg";
      };
      type = attrs;
      description = "Paths to wallpapers";
    };
    monitor_scale = mkOption {
      default = 1;
      type = int;
      description = "For when you need to rescale for monitor size";
    };
    root = mkOption {
      default = "";
      type = with types; uniq str;
      description = "Root partition id";
    };
    themes = mkOption {
      default = { };
      type = attrs;
      description = "My collection of possible colour themes";
    };
    flavour = mkOption {
      default = "frappe";
      type = str;
      description = "Within a given theme you might choose a flavour";
    };
    accent = mkOption {
      default = "teal";
      type = str;
      description = "Within a given theme you might choose a flavour";
    };
    theme = mkOption {
      default = {
        inherit (config.themes.catppuccin."${config.flavour}") rgb hsl hex;
      };
      type = attrs;
      description = "The chosen colour theme for this build";
    };
  };
}
