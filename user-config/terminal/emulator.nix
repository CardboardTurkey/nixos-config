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

  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "catppuccin-${osConfig.flavour}";
        font-size = osConfig.fontSizeSmall;
        keybind = [
          "ctrl+shift+h=goto_split:previous"
          "ctrl+shift+l=goto_split:next"
        ];
        window-padding-x = 30;
        window-padding-y = 30;
        background-opacity = 0.8;
        link-url = true;
      };
    };
    kitty = {
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
  };
}
