{ osConfig, lib, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run,ssh,combi";
      terminal = osConfig.emulator;
      icon-theme = "Zafiro-icons-Dark";
    };
  };
  xdg = {
    configFile."rofi/clean.rasi".source = ../files/rofi/clean.rasi;
    configFile."rofi/colors.rasi".source = ../files/rofi/colors.rasi;
    configFile."rofi/powermenu.rasi".source = ../files/rofi/powermenu.rasi;
  };
  xsession.windowManager.i3 = {
    config = {
      keybindings = lib.mkOptionDefault {
        "${osConfig.i3_mod}+space" = "exec rofi -show drun -theme clean";
        # "${osConfig.i3_mod}+period" = "exec rofi -show emoji -modi emoji";
        "${osConfig.i3_mod}+P" =
          "exec rofi -modi 'Powermenu:rofi-powermenu' -show Powermenu -theme powermenu";
      };
    };
  };
  wayland.windowManager.hyprland = {
    extraConfig = ''
      bindr = SUPER, SUPER_L, exec, rofi -show drun -theme clean
      bind = MOD3, P, exec, rofi -modi 'Powermenu:rofi-powermenu' -show Powermenu -theme powermenu
    '';
  };
}
