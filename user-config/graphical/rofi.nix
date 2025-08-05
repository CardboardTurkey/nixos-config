{
  osConfig,
  pkgs,
  lib,
  launcher-theme,
  rofi-emoji-theme,
  ...
}:
let
  borderGradient = "window { background-image: linear-gradient(45deg,#${osConfig.theme.surface0.hex},#${
    osConfig.theme.${osConfig.accent}.hex
  }); padding: 3px; border-radius: 15px; } mainbox { border-radius: 13px; background-color: @base; }";
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run,ssh,combi";
      terminal = osConfig.emulator;
      icon-theme = "Papirus-Dark";
    };
  };
  xdg.configFile = {
    "rofi/powermenu.rasi".source = ../files/rofi/powermenu.rasi;
  };
  xdg.dataFile = {
    "rofi/themes/launcher.rasi" = {
      source = launcher-theme;
    };
    "rofi/themes/emoji.rasi" = {
      source = rofi-emoji-theme;
    };
    "rofi/themes/shared/colors.rasi".text = ''
      @import "/home/kiran/.local/share/rofi/themes/catppuccin-${osConfig.flavour}.rasi"
      * {
          background:     @base;
          background-alt: @mantle;
          foreground:     @text;
          selected:       @surface0;
          active:         @teal;
          urgent:         @maroon;
      }'';
    "rofi/themes/shared/fonts.rasi".text = ''
      * {
        font: "DejaVu Sans 15";
      }'';
  };
  wayland.windowManager.hyprland.settings = {
    bindr = [
      "SUPER, SUPER_L, exec, ${pkgs.procps}/bin/pkill rofi || rofi -display-drun 🔍 -show drun -show-icons -theme launcher -theme-str '${borderGradient}'"
    ];
    bind = [
      "MOD3, P, exec, rofi -modi 'Powermenu:rofi-powermenu' -show Powermenu -theme powermenu"
      "MOD3, PERIOD, exec, ${pkgs.procps}/bin/pkill rofi || ${lib.getExe pkgs.rofimoji} -a copy --prompt 🔍 --selector-args=\"-no-show-icons -theme emoji -theme-str '${borderGradient} element selected.normal { text-color: @foreground; }'\" -f emojis fontawesome6 arrows runic"
    ];
    layerrule = [
      "ignorezero,rofi"
    ];
  };
}
