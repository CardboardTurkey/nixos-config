{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  scaleArray =
    array: lib.concatStringsSep ", " (map (x: toString (x * osConfig.monitor_scale)) array);
  lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || { ${pkgs.hyprlock}/bin/hyprlock && ${pkgs.eww}/bin/eww open bar; }"; # avoid starting multiple hyprlock instances.
in
{
  wayland.windowManager.hyprland.settings.bind = [ "$mainMod, L, exec, ${lock_cmd}" ];
  services.hypridle = {
    enable = true;
    settings = {
      general =
        {
          lock_cmd = lock_cmd;
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.

        }
        // lib.optionalAttrs (osConfig.hostname != "Osprey") {
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

      listener =
        [

          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
        ]
        ++ (
          if (osConfig.hostname != "Osprey") then
            [
              {
                timeout = 330; # 5.5min
                on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
                on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
              }
            ]
          else
            [ ]
        );
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = false;
      };

      # BACKGROUND
      background = {
        monitor = "";
        path = osConfig.pics.lock;
        blur_passes = 0;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      # GREETINGS
      label = [
        {
          monitor = "";
          text = "Bug off";
          color = "rgba(216, 222, 233, .75)";
          font_size = 55;
          font_family = "DejaVu Sans";
          position = scaleArray [
            185
            320
          ];
          halign = "left";
          valign = "center";
        }

        # Time
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span>$(date +\"%I:%M\")</span>\"";
          color = "rgba(216, 222, 233, .75)";
          font_size = 40;
          font_family = "DejaVu Sans";
          position = scaleArray [
            240
            240
          ];
          halign = "left";
          valign = "center";
        }

        # Day-Month-Date
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
          color = "rgba(216, 222, 233, .75)";
          font_size = 19;
          font_family = "DejaVu Sans";
          position = scaleArray [
            217
            175
          ];
          halign = "left";
          valign = "center";
        }

        # USER
        {
          monitor = "";
          text = "    $USER";
          color = "rgba(216, 222, 233, 0.80)";
          outline_thickness = 0;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          font_size = 16;
          font_family = "DejaVu Sans";
          position = scaleArray [
            275
            (builtins.fromJSON "-140")
          ];
          halign = "left";
          valign = "center";
        }
      ];

      # Profile-Photo
      image = {
        monitor = "";
        path = osConfig.pics.avatar;
        border_size = 2;
        border_color = "rgba(255, 255, 255, .75)";
        size = 95;
        rounding = -1;
        rotate = 0;
        reload_time = -1;
        reload_cmd = "";
        position = scaleArray [
          270
          25
        ];
        halign = "left";
        valign = "center";
      };

      # USER-BOX
      shape = {
        monitor = "";
        size = scaleArray [
          320
          55
        ];
        color = "rgba(255, 255, 255, .1)";
        rounding = -1;
        border_size = 0;
        border_color = "rgba(255, 255, 255, 1)";
        rotate = 0;
        xray = false; # if true, make a "hole" in the background (rectangle of specified size, no rotation)

        position = scaleArray [
          160
          (builtins.fromJSON "-140")
        ];
        halign = "left";
        valign = "center";
      };

      # INPUT FIELD
      input-field = {
        monitor = "";
        size = scaleArray [
          320
          55
        ];
        outline_thickness = 0;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(255, 255, 255, 0)";
        inner_color = "rgba(255, 255, 255, 0.1)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        font_family = "DejaVu Sans";
        placeholder_text = "<i><span foreground=\"##ffffff99\">🔒  Enter Pass</span></i>";
        hide_input = false;
        position = scaleArray [
          160
          (builtins.fromJSON "-220")
        ];
        halign = "left";
        valign = "center";
      };
    };
  };
}
