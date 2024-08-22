{ lib, osConfig, ... }: {

  xsession.windowManager.i3 = {
    config = {
      keybindings = lib.mkOptionDefault {
        "${osConfig.i3_mod}+Control+Return" = "exec alacritty";
        "${osConfig.i3_mod}+Return" =
          "workspace 1; exec pgrep alacritty || alacritty -e tmuxup";
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = osConfig.font_size_small;
        normal = {
          family = "Bitstream Vera Sans Mono";
          style = "Roman";
        };
      };
      window = {
        opacity = 0.5;
        padding.x = 20;
        padding.y = 10;
        dynamic_padding = true;
      };
      env.WINIT_X11_SCALE_FACTOR = "1";
      colors = {
        primary = {
          background = "#${osConfig.nord0}";
          foreground = "#${osConfig.nord4}";
          dim_foreground = "#a5abb6";
        };
        cursor = {
          text = "#${osConfig.nord0}";
          cursor = "#${osConfig.nord4}";
        };
        vi_mode_cursor = {
          text = "#${osConfig.nord0}";
          cursor = "#${osConfig.nord4}";
        };
        selection = {
          text = "CellForeground";
          background = "#${osConfig.nord3}";
        };
        search.matches = {
          foreground = "CellBackground";
          background = "#${osConfig.nord8}";
        };
        footer_bar = {
          background = "#${osConfig.nord2}";
          foreground = "#${osConfig.nord4}";
        };
        normal = {
          black = "#${osConfig.nord1}";
          red = "#${osConfig.nord11}";
          green = "#${osConfig.nord14}";
          yellow = "#${osConfig.nord13}";
          blue = "#${osConfig.nord9}";
          magenta = "#${osConfig.nord15}";
          cyan = "#${osConfig.nord8}";
          white = "#${osConfig.nord5}";
        };
        bright = {
          black = "#${osConfig.nord3}";
          red = "#${osConfig.nord11}";
          green = "#${osConfig.nord14}";
          yellow = "#${osConfig.nord13}";
          blue = "#${osConfig.nord9}";
          magenta = "#${osConfig.nord15}";
          cyan = "#${osConfig.nord7}";
          white = "#${osConfig.nord6}";
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
}
