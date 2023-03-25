# This file contains definitions of the nord colours
# See https://www.nordtheme.com/docs/colors-and-palettes

{ lib, ... }:

with lib;
{
  options = {
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
      default = 17.0;
      type = with types; float;
      description = "Large font size";
    };
    nord0 = mkOption {
      default = "2e3440";
      type = with types; uniq str;
      description = "Very Very dark blue";
    };
    nord1 = mkOption {
      default = "3b4252";
      type = with types; uniq str;
      description = "Very dark blue";
    };
    nord2 = mkOption {
      default = "434c5e";
      type = with types; uniq str;
      description = "Dark blue";
    };
    nord3 = mkOption {
      default = "4c566a";
      type = with types; uniq str;
      description = "Slightly less dark blue";
    };
    nord4 = mkOption {
      default = "d8dee9";
      type = with types; uniq str;
      description = "Light grey";
    };
    nord5 = mkOption {
      default = "e5e9f0";
      type = with types; uniq str;
      description = "Lighter grey";
    };
    nord6 = mkOption {
      default = "eceff4";
      type = with types; uniq str;
      description = "Lightest grey";
    };
    nord7 = mkOption {
      default = "8fbcbb";
      type = with types; uniq str;
      description = "Turquoise";
    };
    nord8 = mkOption {
      default = "88c0d0";
      type = with types; uniq str;
      description = "Lightest blue";
    };
    nord9 = mkOption {
      default = "81a1c1";
      type = with types; uniq str;
      description = "Lighter Blue";
    };
    nord10 = mkOption {
      default = "5e81ac";
      type = with types; uniq str;
      description = "Light Blue";
    };
    nord11 = mkOption {
      default = "bf616a";
      type = with types; uniq str;
      description = "Red";
    };
    nord12 = mkOption {
      default = "d08770";
      type = with types; uniq str;
      description = "Orange";
    };
    nord13 = mkOption {
      default = "ebcb8b";
      type = with types; uniq str;
      description = "Yellow";
    };
    nord14 = mkOption {
      default = "a3be8c";
      type = with types; uniq str;
      description = "Green";
    };
    nord15 = mkOption {
      default = "b48ead";
      type = with types; uniq str;
      description = "Purple";
    };
    allowed_unfree = mkOption {
      default = [];
      type = with types; listOf str;
      description = "Allowed unfree packages";
    };
  };
}


