{
  pkgs,
  lib,
  osConfig,
  ...
}:
{

  xsession.windowManager.i3 = {
    config = {
      keybindings = lib.mkOptionDefault {
        "${osConfig.i3_mod}+Control+Return" = "exec ${pkgs.${osConfig.emulator}}/bin/${osConfig.emulator}";
        "${osConfig.i3_mod}+Return" =
          "workspace 1; exec pgrep ${pkgs.${osConfig.emulator}}/bin/${osConfig.emulator} || ${pkgs.${osConfig.emulator}}/bin/${osConfig.emulator} -e tmuxup";
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = osConfig.fontSizeSmall;
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

  programs.kitty = {
    enable = true;
    settings = {
      cursor_trail = 1;
      font_family = "monospace";
      font_size = builtins.toString osConfig.fontSizeSmall;
      window_padding_width = 10;
      enable_audio_bell = false;
      background_opacity = 0.85;
    };
  };
}
