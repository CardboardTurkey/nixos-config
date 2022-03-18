# TODO: sort out colours
# * Define them all as variables
# * Nordify everything or make some softer in bar

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
          height = "40";
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

          # Prefer Bitstream as it has minimal unicode coverage and so Font awesome and Noto can display icons
          # Add DejaVu as fallback
          font-0 = "Bitstream Vera Sans:style=Roman:pixelsize=15;3";
          font-1 = "Font Awesome 5 Free,Font Awesome 5 Free Regular:style=Regular:size=15;3";
          font-2 = "Font Awesome 5 Free,Font Awesome 5 Free Solid:style=Solid:size=15;3";
          font-3 = "Font Awesome 5 Brands,Font Awesome 5 Brands Regular:style=Regular:style=Solid:size=15;3";
          font-4 = "Noto Color Emoji:style=Regular:scale=8;2";
          font-5 = "DejaVu Sans:style=Roman:pixelsize=15;3";

          modules-left = "i3";
          # modules-center = "player-mpris-tail";
          modules-right = "pulseaudio battery filesystem memory cpu wlan eth xkeyboard date";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";

          enable-ipc = true;
        };
        "module/eth" = {
          type = "internal/network";
          interface = "enp0s31f6";
          interval = "3.0";

          format-connected = "<label-connected> <ramp-signal>";
          format-connected-underline = "#9f78e1";
          label-connected-foreground = "#9f78e1";
          label-connected = "";

          format-disconnected = "";

          ramp-signal-0 = "😵";
          ramp-signal-1 = "😟";
          ramp-signal-2 = "😐";
          ramp-signal-3 = "😀";
          ramp-signal-4 = "🥵";
          ramp-signal-foreground = "${foreground-alt}";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = "2";
          format-prefix = "";
          format-prefix-foreground = "${nord12}";
          format-underline = "${nord12}";
          label = "%percentage:2%%";
        };
        "module/memory" = {
          type = "internal/memory";
          format-prefix = " ";
          format-prefix-foreground = "${nord8}";
          format-underline = "${nord8}";
          label = "%percentage_used%%";
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
        "module/wlan" = {
          type = "internal/network";
          interface = "wlp0s20f3";
          interval = "1.0";

          format-connected = "<label-connected> <ramp-signal>";
          format-connected-underline = "#9f78e1";
          label-connected-foreground = "#9f78e1";
          label-connected = "";

          format-disconnected = "";

          ramp-signal-0 = "😵";
          ramp-signal-1 = "😟";
          ramp-signal-2 = "😐";
          ramp-signal-3 = "😀";
          ramp-signal-4 = "🥵";
          ramp-signal-foreground = "${foreground-alt}";
        };
        "module/date" = {
          type = "internal/date";
          interval = "1.0";

          date = "";
          date-alt = " %A, %d %B %Y";

          time = "%H:%M";
          time-alt = "%H:%M:%S";

          format-prefix = " ";
          format-prefix-foreground = "${nord15}";
          format-underline = "${nord15}";

          label = "%time%%date%";
        };
        "module/filesystem" = {
          type = "internal/fs";
          interval = "25";

          mount-0 = "/";

          format-mounted = "%{F${nord15}}%{F-} <label-mounted>";
          format-mounted-underline = "${nord15}";

          format-unmounted = "<label-unmounted>";
          format-unmounted-underline = "${nord15}";


          label-mounted = "%percentage_used%%";
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
          label-focused-padding = "2";

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
          bar-volume-fill = "─";
          bar-volume-empty = "─";
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