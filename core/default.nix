{ lib, ... }:

with lib;
{
  imports =
    [
      ./nord.nix
    ];

  options = {
    email = mkOption {
      default = "kostrolenk@gmail.com";
      type = with types; uniq str;
      description = "Email address (for git)";
    };
    eth = mkOption {
      default = "eth0";
      type = with types; uniq str;
      description = "Ethernet interface";
    };
    wlan = mkOption {
      default = "wlan0";
      type = with types; uniq str;
      description = "Wireless interface";
    };
    battery = mkOption {
      default = "BAT0";
      type = with types; uniq str;
      description = "As given in /sys/class/power_supply/";
    };
    adapter = mkOption {
      default = "AC";
      type = with types; uniq str;
      description = "As given in /sys/class/power_supply/";
    };
    edp1 = mkOption {
      default = "";
      type = with types; uniq str;
      description = "Fingerprint for laptop screen";
    };
    root = mkOption {
      default = "";
      type = with types; uniq str;
      description = "Root partition id";
    };
    hostname = mkOption {
      default = "";
      type = with types; uniq str;
      description = "Network hostname";
    };
    i3_mod = mkOption {
      default = "Mod4";
      type = with types; uniq str;
      description = "Modifier name to go in i3 config";
    };
    web_dir = mkOption {
      default = "/home/kiran/gitlab/cardboardturkey/website";
      type = with types; uniq str;
      description = "Modifier name to go in i3 config";
    };
    font_size_small = mkOption {
      default = 12.0;
      type = with types; float;
      description = "Small font size";
    };
    font_size_medium = mkOption {
      default = 15.0;
      type = with types; float;
      description = "Medium font size";
    };
    font_size_large = mkOption {
      default = 21.0;
      type = with types; float;
      description = "Large font size";
    };
    allowed_unfree = mkOption {
      default = [ ];
      type = with types; listOf str;
      description = "Allowed unfree packages";
    };
  };
}
