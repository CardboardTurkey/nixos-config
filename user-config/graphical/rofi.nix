{ osConfig, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run,ssh,combi";
      terminal = osConfig.emulator;
      icon-theme = "Zafiro-icons-Dark";
    };
  };
  xdg.configFile = {
    "rofi/clean.rasi".source = ../files/rofi/clean.rasi;
    "rofi/colors.rasi".source = ../files/rofi/colors.rasi;
    "rofi/powermenu.rasi".source = ../files/rofi/powermenu.rasi;
  };
  wayland.windowManager.hyprland.settings = {
    bindr = [
      "SUPER, SUPER_L, exec, rofi -display-drun 🔍 -show drun -show-icons -drun-display-format ' {name}' -theme-str 'window { background-image: linear-gradient(45deg,#${osConfig.theme.surface0.hex},#${
        osConfig.theme.${osConfig.accent}.hex
      }); padding: 2px; border-radius: 10px; } mainbox {  border-radius: 7px; }'"
    ];
    bind = [
      "MOD3, P, exec, rofi -modi 'Powermenu:rofi-powermenu' -show Powermenu -theme powermenu"
    ];
    layerrule = [ "ignorezero,rofi" ];
  };
}
