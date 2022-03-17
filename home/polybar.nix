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
      package = pkgs.polybar.override {
        i3Support = true;
        alsaSupport = true;
        iwSupport = true;
        pulseSupport = true;
      };
      # Doesnt seem to be doing anything:
      script = ''
        polybar-msg cmd quit
        polybar the_bar &
      '';
      settings = {
        "settings" = {
          screenchange-reload = "true";
        };
        "bar/the_bar" = {
          width = "100%";
          height = "35";
          radius = "0.0";
          fixed-center = "false";

          background = "${background}";
          foreground = "${foreground}";

          line-size = "3";
          line-color = "#f00";

          border-size = "0";

          padding-left = "0";
          padding-right = "2";

          module-margin-left = "1";
          module-margin-right = "2";

          font-0 = "DejaVu Sans Mono:style=Book:pixelsize=15;3";
          font-1 = "Font Awesome 5 Free,Font Awesome 5 Free Regular:style=Regular:size=15;3";
          font-2 = "Font Awesome 5 Free,Font Awesome 5 Free Solid:style=Solid:size=15;3";
          font-3 = "Font Awesome 5 Brands,Font Awesome 5 Brands Regular:style=Regular:style=Solid:size=15;3";
          font-4 = "Noto Color Emoji:style=Regular:scale=8;2";

          modules-left = "i3";
          modules-center = "player-mpris-tail";
          modules-right = "pulseaudio filesystem battery xkeyboard memory cpu wlan eth date";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";

          enable-ipc = true;
        };
        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist-0 = "num lock";

          format-prefix = "";
          format-prefix-foreground = "${nord11}";
          format-prefix-underline = "${nord11}";

          label-layout = "%layout%";
          label-layout-underline = "${nord11}";

          label-indicator-padding = "2";
          label-indicator-margin = "1";
          label-indicator-background = "${nord11}";
          label-indicator-underline = "${nord11}";
        };
        "module/date" = {
          type = "internal/date";
          interval = "1.0";

          date = "";
          date-alt = " %A, %d %B %Y";

          time = "%H:%M";
          time-alt = "%H:%M:%S";

          format = "<label>";
          format-foreground = "${nord15}";
          format-underline = "${nord15}";

          label = "%time%%date%";
          label-foreground = "${foreground}";
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

          label-focused = "%icon%";
          label-focused-background = "${background-alt}";
          label-focused-underline = "${primary}";
          label-focused-padding = "1";

          label-unfocused = "%icon%";
          label-unfocused-padding = "\${self.label-focused-padding}";

          label-visible = "%icon%";
          label-visible-padding = "\${self.label-focused-padding}";

          label-urgent = "%icon%";
          label-urgent-background = "${alert}";
          label-urgent-padding = "\${self.label-focused-padding}";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";

          format-volume = "<label-volume> <bar-volume>";
          label-volume = "%percentage%%";
          label-volume-foreground = "\${root.foreground}";

          label-muted = " muted";
          label-muted-foreground = "#666";

          bar-volume-width = "10";
          bar-volume-foreground-0 = "#55aa55";
          bar-volume-foreground-1 = "#55aa55";
          bar-volume-foreground-2 = "#55aa55";
          bar-volume-foreground-3 = "#55aa55";
          bar-volume-foreground-4 = "#55aa55";
          bar-volume-foreground-5 = "#f5a70a";
          bar-volume-foreground-6 = "#ff5555";
          bar-volume-gradient = "false";
          bar-volume-indicator = "";
          bar-volume-indicator-font = "2";
          bar-volume-fill = "─";
          bar-volume-fill-font = "2";
          bar-volume-empty = "─";
          bar-volume-empty-font = "2";
          bar-volume-empty-foreground = "${foreground-alt}";
        };
        "module/battery" = {
          type = "internal/battery";
          # full-at = "99";
          battery = "BAT0";
          adapter = "AC";
          format-charging = "<animation-charging> <label-charging>";
          format-discharging = "<ramp-capacity> <label-discharging>";
          format-full = "<ramp-capacity> <label-full>";

          format-low = "<label-low> <animation-low>";

          label-charging = "%percentage%%";
          label-discharging = "%percentage%%";
          label-full = "👌";

          label-low = "BATTERY LOW";

          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";

          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-framerate = "900";

          animation-discharging-0 = "";
          animation-discharging-1 = "";
          animation-discharging-2 = "";
          animation-discharging-3 = "";
          animation-discharging-4 = "";
          animation-discharging-framerate = "500";

          animation-low-0 = "";
          animation-low-1 = "";
          animation-low-framerate = "200";
        };
      };
    };
  };
}