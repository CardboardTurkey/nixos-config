{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          family = "DejaVuSansMono Nerd Font Mono";
          size = 15;
          offset.x = 1;
        };
        window = {
          opacity = 0.8;
          padding.x = 5;
          padding.y = 5;
          dynamic_padding = true;
        };
        colors = {
          primary = {
            background = "#${config.nord0}";
            foreground = "#${config.nord4}";
            dim_foreground = "#a5abb6";
          };
          cursor = {
            text = "#${config.nord0}";
            cursor = "#${config.nord4}";
          };
          vi_mode_cursor = {
            text = "#${config.nord0}";
            cursor = "#${config.nord4}";
          };
          selection = {
            text = "CellForeground";
            background = "#${config.nord3}";
          };
          search = {
            matches = {
              foreground = "CellBackground";
              background = "#${config.nord8}";
            };
            bar = {
              background = "#${config.nord2}";
              foreground = "#${config.nord4}";
            };
          };
          normal = {
            black = "#${config.nord1}";
            red = "#${config.nord11}";
            green = "#${config.nord14}";
            yellow = "#${config.nord13}";
            blue = "#${config.nord9}";
            magenta = "#${config.nord15}";
            cyan = "#${config.nord8}";
            white = "#${config.nord5}";
          };
          bright = {
            black = "#${config.nord3}";
            red = "#${config.nord11}";
            green = "#${config.nord14}";
            yellow = "#${config.nord13}";
            blue = "#${config.nord9}";
            magenta = "#${config.nord15}";
            cyan = "#${config.nord7}";
            white = "#${config.nord6}";
          };
          dim = {
            black = "#373e4d";
            red = "#94545d";
            green = "#809575";
            yellow = "#b29e75";
            blue = "#68809a";
            magenta = "#8c738c";
            cyan = "#6d96a5";
            white = "#aeb3bb";
          };
        };
      };
    };
  };
}