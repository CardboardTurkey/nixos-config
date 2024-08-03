{ lib, ... }:

with lib;
with types; {
  imports = [ ./nord.nix ./hardware.nix ./keys.nix ];

  options = {
    email = mkOption {
      default = "kiran@ostrolenk.co.uk";
      type = uniq str;
      description = "Email address (for git)";
    };
    hostname = mkOption {
      default = "";
      type = uniq str;
      description = "Network hostname";
    };
    i3_mod = mkOption {
      default = "Mod4";
      type = uniq str;
      description = "Modifier name to go in i3 config";
    };
    web_dir = mkOption {
      default = "/home/kiran/git/cardboardturkey/website";
      type = uniq str;
      description = "Modifier name to go in i3 config";
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
      default = { };
      type = attrs;
      description = "Paths to wallpapers";
    };
    monitor_scale = mkOption {
      default = 1.0;
      type = float;
      description = "For when you need to rescale for monitor size";
    };
  };
}
