{ config, lib, pkgs, ... }:
let
  background = "#2e3440";
  background-alt = "#434c5e";
  foreground = "#eceff4";
  foreground-alt = "#555";
  primary = "#ebcb8b";
  secondary = "#e60053";
  alert = "#bf616a";
  nord3 = "#4c566a";
  nord8 = "#88c0d0";
  nord9 = "#81a1c1";
  nord11 = "#bf616a";
  nord12 = "#d08770";
  nord14 = "#a3be8c";
  nord15 = "#b48ead";
in
{
  home-manager.users.kiran = { pkgs, ... }: {
    services.polybar = {
      enable = true;
      script = ''
        export MON_MAIN=$(xrandr | grep primary | cut -d' ' -f1)
        polybar the_bar &
      '';
      settings = {
        "bar/the_bar" = {
          monitor = "\${env:MON_MAIN}";
          width = "100%";
          height = "35";
          radius = "0.0";
          fixed-center = "false";

          background = "${background}";
          foreground = "${foreground}";

          line-size = "3";
          line-color = "#f00";

          border-size = "0";
          border-bottom-size = "0";
          border-color = "#00000000";

          padding-left = "0";
          padding-right = "2";

          module-margin-left = "1";
          module-margin-right = "2";

          font-0 = "DejaVuSansMono Nerd Font Mono:style=Book:pixelsize=13;3";
          font-1 = "Font Awesome 5 Free,Font Awesome 5 Free Regular:style=Regular:size=13;3";
          font-2 = "Font Awesome 5 Free,Font Awesome 5 Free Solid:style=Solid:size=13;3";
          font-3 = "Font Awesome 5 Brands,Font Awesome 5 Brands Regular:style=Regular:style=Solid:size=13;3";
          font-4 = "Noto Color Emoji:style=Regular:scale=8;2";

          modules-left = "i3";
          modules-center = "player-mpris-tail";
          modules-right = "pulseaudio filesystem battery-combined-udev xkeyboard memory cpu wlan eth date";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
        };
        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist-0 = "num lock";

          format-prefix = " ";
          format-prefix-foreground = "${nord11}";
          format-prefix-underline = "${nord11}";

          label-layout = "%layout%";
          label-layout-underline = "${nord11}";

          label-indicator-padding = "2";
          label-indicator-margin = "1";
          label-indicator-background = "${nord11}";
          label-indicator-underline = "${nord11}";
        };
        "module/filesystem" = {
          type = "internal/fs";
          interval = "25";

          mount-0 = "/";

          label-mounted = " %percentage_used%%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "${foreground-alt}";
        };
        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = "true";
          wrapping-scroll = "false";

          ws-icon-0 = "1;";
          ws-icon-1 = "2;";
          ws-icon-2 = "3;";
          ws-icon-3 = "4;";
          ws-icon-4 = "5;";
          ws-icon-5 = "6;";
          ws-icon-6 = "7;";
          ws-icon-7 = "8;";
          ws-icon-default = "";

          label-mode-padding = "2";
          label-mode-foreground = "#000";
          label-mode-background = "${primary}";

          label-focused = "%icon%";
          label-focused-background = "${background-alt}";
          label-focused-underline = "${primary}";
          label-focused-padding = "2";

          label-unfocused = "%icon%";
          label-unfocused-padding = "2";

          label-visible = "%icon%";
          label-visible-padding = "\${self.label-unfocused-padding}";

          label-urgent = "%icon%";
          label-urgent-background = "${alert}";
          label-urgent-padding = "2";
        };
      };
    };
  };
}