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
        opacity = 0.78;
        padding.x = 20;
        padding.y = 10;
        dynamic_padding = true;
      };
      env.WINIT_X11_SCALE_FACTOR = "1";
    };
  };
}
