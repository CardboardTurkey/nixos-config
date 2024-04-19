{ config, lib, ... }:
{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        modi = "drun,run,ssh,combi";
        terminal = "alacritty";
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
          "${config.i3_mod}+space" = "exec rofi -show drun -theme clean";
          # "${config.i3_mod}+period" = "exec rofi -show emoji -modi emoji";
          "${config.i3_mod}+P" = "exec rofi -modi 'Powermenu:rofi-powermenu' -show Powermenu -theme powermenu";
        };
      };
    };
    wayland.windowManager.hyprland = {
      extraConfig = ''
        bind = MOD3, SPACE, exec, rofi -show drun -theme clean
        bind = MOD3, P, exec, rofi -modi 'Powermenu:rofi-powermenu' -show Powermenu -theme powermenu
      '';
      };
    };
  }
