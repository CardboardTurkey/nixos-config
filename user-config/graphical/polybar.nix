{ config, pkgs, ... }:
let
  # Hardware
  eth_interface = "${config.eth}";
  wlan_interface = "${config.wlan}";
  battery = "${config.battery}";
  adapter = "${config.adapter}";

  # Lets choose some colours!
  # Nord colours defined in `../core/nord.nix`
  foreground = "#${config.nord6}";
  background = "#ee${config.nord0}";
  # Workspace colours
  ws_focused = "#${config.nord7}";
  ws_unfocused = "#${config.nord3}";
  ws_urgent = "#${config.nord11}";
  # Pulseaudio colours
  muted_colour = "#${config.nord3}";
  quiet_colour = "#${config.nord14}";
  loud_colour = "#${config.nord12}";
  booming_colour = "#${config.nord11}";
  volume_bar = "#${config.nord4}";
  # The other module colours
  date_colour = "#${config.nord15}";
  xkeyboard_colour = "#${config.nord12}";
  wired_colour = "#${config.nord13}";
  wireless_colour = "#${config.nord13}";
  dirtygit_colour = "#${config.nord11}";
  totd_colour = "#${config.nord4}";
  cpu_colour = "#${config.nord10}";
  memory_colour = "#${config.nord9}";
  filesystem_colour = "#${config.nord8}";
  battery_colour = "#${config.nord7}";
  battery_warning = "#${config.nord11}";

  # TODO: handle more than 2 monitors
  barup = pkgs.writeShellScriptBin "barup" ''
    polybar-msg cmd quit
    polybar main &disown
    readarray -t monitors < <(polybar --list-monitors | cut -d':' -f1)
    [ ''${#monitors[@]} -gt 1 ] && MONITOR=''${monitors[1]} polybar aux &disown
  '';

in
{

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    noto-fonts-emoji
    font-awesome
    ttf_bitstream_vera
  ];

  environment.systemPackages = [ pkgs.local.dirtygit pkgs.local.thing-of-the-day barup ];
  services.dirtygit.enable = true;

  home-manager.users.kiran = { pkgs, ... }: {

    programs.autorandr = {
      enable = true;
      hooks.postswitch = {
        "polybar" = "${barup}/bin/barup";
      };
    };

    xdg.configFile."dirtygit".text = ''
      ~/gitlab/cardboardturkey/nixos-config
      ~/gitlab/cardboardturkey/dirtygit
      ~/gitlab/cardboardturkey/pdgid
      ~/gitlab/cardboardturkey/website
      ~/gitlab/kiran-rust-course/project
    '';

    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        iwSupport = true;
        pulseSupport = true;
      };
      # Doesnt seem to be doing anything:
      script = "${barup}/bin/barup";
      settings = {
        "settings" = {
          screenchange-reload = "true";
        };
        "bar/base" = {
          width = "1898";
          height = "37";
          offset-x = "11";
          offset-y = "11";
          override-redirect = true;
          wm-restack = "i3";

          background = "${background}";
          foreground = "${foreground}";

          overline-size = "3";
          underline-size = "3";

          padding-left = "3";
          padding-right = "2";

          module-margin = "2";

          # Prefer Bitstream as it has minimal unicode coverage and so Font awesome and Noto can display icons
          # Add DejaVu (Nerd font) as fallback
          font-0 = "Bitstream Vera Sans:style=Roman:pixelsize=${builtins.toString config.font_size_medium};3";
          font-1 = "Font Awesome 6 Free,Font Awesome 6 Free Solid:style=Solid:size=${builtins.toString config.font_size_medium};3";
          font-2 = "Font Awesome 6 Free,Font Awesome 6 Free Regular:style=Regular:size=${builtins.toString config.font_size_medium};3";
          font-3 = "Font Awesome 6 Brands,Font Awesome 6 Brands Regular:style=Regular:size=${builtins.toString config.font_size_medium};3";
          font-4 = "Noto Color Emoji:style=Regular:scale=8;2";
          font-5 = "DejaVu Sans:style=Roman:pixelsize=${builtins.toString config.font_size_medium};3";
          font-6 = "Font Awesome 6 Free,Font Awesome 6 Free Solid:style=Solid:size=19;4";
          font-7 = "Font Awesome 6 Free,Font Awesome 6 Free Solid:style=Solid:size=12;2";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";

          enable-ipc = true;
        };
        "bar/main" = {
          "inherit" = "bar/base";
          modules-left = "i3";
          # modules-center = "player-mpris-tail";
          modules-right = "pulseaudio battery filesystem memory cpu wired-network wireless-network xkeyboard dirtygit date";
          fixed-center = false;
        };
        "bar/aux" = {
          monitor = "\${env:MONITOR:}";
          "inherit" = "bar/base";
          modules-left = "i3";
          modules-center = "totd";
          fixed-center = true;
        };
        "module/dirtygit" = {
          type = "custom/script";
          exec = "dg -n";
          interval = 2;
          format-prefix-foreground = "${dirtygit_colour}";
          format-prefix = "⚠️";
          format-prefix-font = "5";
          format-prefix-padding-right = "5pt";
          format-underline = "${dirtygit_colour}";

          label-padding-right = "5pt";
        };
        "module/totd" = {
          type = "custom/script";
          exec = "totd -d 45m -w 100";
          click-left = "firefox /home/kiran/.cache/thing-of-the-day";
          tail = "true";
          format-foreground = "${totd_colour}";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = "2";
          format-prefix = "";
          format-prefix-foreground = "${cpu_colour}";
          format-underline = "${cpu_colour}";
          label = "%percentage:2%%";
        };
        "module/memory" = {
          type = "internal/memory";
          format-prefix = " ";
          format-prefix-foreground = "${memory_colour}";
          format-underline = "${memory_colour}";
          label = "%percentage_used%%";
        };
        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist-0 = "num lock";

          format-prefix = "";
          format-prefix-padding-right = "5pt";
          format-prefix-foreground = "${xkeyboard_colour}";
          format-underline = "${xkeyboard_colour}";

          label-layout = "%layout%";
          # label-layout-underline = "${xkeyboard_colour}";

        };
        "module/wired-network" = {
          type = "internal/network";
          interface = "${eth_interface}";
          interval = "1.0";

          format-connected = "<label-connected> <ramp-signal>";
          format-connected-underline = "${wired_colour}";
          format-connected-font = "5";
          label-connected-foreground = "${wired_colour}";
          label-connected = "";
          label-connected-padding-right = "5pt";

          format-disconnected = "";

          ramp-signal-0 = "😵";
          ramp-signal-1 = "😟";
          ramp-signal-2 = "😐";
          ramp-signal-3 = "😀";
          ramp-signal-4 = "🥵";
        };
        "module/wireless-network" = {
          type = "internal/network";
          interval = "1.0";
          interface = "${wlan_interface}";

          format-connected = "<label-connected><ramp-signal>";
          format-connected-underline = "${wireless_colour}";
          format-connected-font = "5";
          label-connected-foreground = "${wireless_colour}";
          label-connected = "";
          label-connected-padding-right = "5pt";
          label-connected-padding-top = "3pt";

          format-disconnected = "";

          ramp-signal-0 = "😵";
          ramp-signal-1 = "😟";
          ramp-signal-2 = "😐";
          ramp-signal-3 = "😀";
          ramp-signal-4 = "🥵";
        };
        "module/date" = {
          type = "internal/date";
          interval = "1.0";

          date = "";
          date-alt = " %A, %d %B %Y";

          time = "%H:%M";
          time-alt = "%H:%M:%S";

          format-prefix = " ";
          format-prefix-foreground = "${date_colour}";
          format-underline = "${date_colour}";

          label = "%time%%date%";
        };
        "module/filesystem" = {
          type = "internal/fs";
          interval = "25";

          mount-0 = "/";

          format-mounted = "%{F${filesystem_colour}}%{F-} <label-mounted>";
          format-mounted-underline = "${filesystem_colour}";

          format-unmounted = "<label-unmounted>";
          format-unmounted-underline = "${filesystem_colour}";


          label-mounted = "%percentage_used%%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "${filesystem_colour}";
        };
        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = "true";
          wrapping-scroll = "false";

          ws-icon-0 = "1;";
          ws-icon-1 = "2;";
          ws-icon-3 = "3;";
          ws-icon-4 = "4;";
          ws-icon-2 = "5;";
          ws-icon-5 = "6;";
          ws-icon-6 = "7;";
          ws-icon-7 = "8;";
          ws-icon-8 = "9;";
          ws-icon-default = "";

          label-focused = "%icon%";
          label-focused-foreground = "${ws_focused}";
          label-focused-padding = "2";
          label-focused-font = "7";

          label-unfocused = "\${self.label-focused}";
          label-unfocused-foreground = "${ws_unfocused}";
          label-unfocused-padding = "\${self.label-focused-padding}";
          label-unfocused-font = "8";

          label-visible = "\${self.label-focused}";
          label-visible-foreground = "${ws_unfocused}";
          label-visible-padding = "\${self.label-focused-padding}";
          label-visible-font = "\${self.label-unfocused-font}";

          label-urgent = "\${self.label-focused}";
          label-urgent-foreground = "${ws_urgent}";
          label-urgent-padding = "\${self.label-focused-padding}";
          label-urgent-font = "\${self.label-focused-font}";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";

          format-volume = "<bar-volume> <label-volume>";

          label-volume = "%percentage%%";
          label-volume-foreground = "${foreground}";

          label-muted = " muted";
          label-muted-foreground = "${muted_colour}";

          bar-volume-width = "10";
          bar-volume-foreground-0 = "${quiet_colour}";
          bar-volume-foreground-1 = "${quiet_colour}";
          bar-volume-foreground-2 = "${quiet_colour}";
          bar-volume-foreground-3 = "${quiet_colour}";
          bar-volume-foreground-4 = "${quiet_colour}";
          bar-volume-foreground-5 = "${loud_colour}";
          bar-volume-foreground-6 = "${booming_colour}";
          bar-volume-gradient = "false";
          bar-volume-indicator = "";
          bar-volume-fill = "─";
          bar-volume-empty = "─";
          bar-volume-empty-foreground = "${volume_bar}";
        };
        "module/battery" = {
          type = "internal/battery";
          # full-at = "99";
          battery = "${battery}";
          adapter = "${adapter}";

          format-charging = "<animation-charging> <label-charging>";
          format-discharging = "<ramp-capacity> <label-discharging>";
          format-full = "<ramp-capacity> <label-full>";
          format-low = "<label-low> <animation-low>";

          format-charging-underline = "${battery_colour}";
          format-discharging-underline = "${battery_colour}";
          format-full-underline = "${battery_colour}";
          format-low-underline = "${battery_colour}";

          label-charging = "%percentage%%";
          label-discharging = "%percentage%%";
          label-full = "👌";

          label-low = "BATTERY LOW";

          ramp-capacity-0 = "%{F${battery_colour}}%{F-}";
          ramp-capacity-1 = "%{F${battery_colour}}%{F-}";
          ramp-capacity-2 = "%{F${battery_colour}}%{F-}";
          ramp-capacity-3 = "%{F${battery_colour}}%{F-}";
          ramp-capacity-4 = "%{F${battery_colour}}%{F-}";

          animation-charging-0 = "%{F${battery_colour}}%{F-}";
          animation-charging-1 = "%{F${battery_colour}}%{F-}";
          animation-charging-2 = "%{F${battery_colour}}%{F-}";
          animation-charging-3 = "%{F${battery_colour}}%{F-}";
          animation-charging-4 = "%{F${battery_colour}}%{F-}";
          animation-charging-framerate = "900";

          animation-discharging-0 = "%{F${battery_colour}}%{F-}";
          animation-discharging-1 = "%{F${battery_colour}}%{F-}";
          animation-discharging-2 = "%{F${battery_colour}}%{F-}";
          animation-discharging-3 = "%{F${battery_colour}}%{F-}";
          animation-discharging-4 = "%{F${battery_colour}}%{F-}";
          animation-discharging-framerate = "500";

          animation-low-0 = "%{F${battery_warning}}%{F-}";
          animation-low-1 = "%{F${battery_colour}}%{F-}";
          animation-low-framerate = "200";
        };
      };
    };
  };
}













