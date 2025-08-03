{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  scaleArray = array: lib.concatStringsSep ", " (map (x: toString (x * osConfig.monitorScale)) array);
  lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || { ${pkgs.hyprlock}/bin/hyprlock && ${pkgs.hyprland}/bin/hyprctl layers | ${pkgs.ripgrep}/bin/rg bar-0 || systemctl restart --user hyprpanel.service; }"; # avoid starting multiple hyprlock instances.
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
  catppuccin.hyprlock.useDefaultConfig = false;
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        monitor = "";
        path = if (osConfig.hostname == "Osprey") then osConfig.pics.lock else "screenshot";
        blur_passes = 3;
        blur_size = 8;
        color = "$base";
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 1, 1, 0, 0"
          "easeOutQuint, 0.22, 1, 0.36, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
        ];
        animation = [
          "fadeIn, 1, 5, easeOutCubic"
          "fadeOut, 1, 5, easeOutQuint"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      label = [
        {
          # Time
          monitor = "";
          text = ''cmd[update:1000] echo "$TIME"'';
          color = "$text";
          font_size = osConfig.monitorScale * 55;
          # font_family = "DejaVuSansM Nerd Font";
          position = scaleArray [
            (builtins.fromJSON "-100")
            (builtins.fromJSON "60")
          ];
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = osConfig.monitorScale * 10;
        }
      ];

      input-field = {
        monitor = "";
        size = scaleArray [
          250
          50
        ];
        outline_thickness = osConfig.monitorScale * 3;
        dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        outer_color = "$teal";
        inner_color = "$surface0";
        font_color = "$text";
        fade_on_empty = true;
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = "<i>the way is shut</i>"; # Text rendered in the input box when it's empty.
        hide_input = false;
        rounding = -1; # -1 means complete rounding (circle/oval)
        check_color = "$peach";
        fail_color = "$red"; # if authentication failed, changes outer_color and fail message color
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false; # change color if numlock is off
        swap_font_color = false; # see below
        position = scaleArray [
          0
          (builtins.fromJSON "-20")
        ];
        halign = "center";
        valign = "center";
      };

      image = {
        monitor = "";
        path = osConfig.pics.small;
        size = osConfig.monitorScale * 280; # lesser side if not 1:1 ratio
        rounding = -1; # negative values mean circle
        border_size = osConfig.monitorScale * 3;
        border_color = "$overlay2";
        rotate = 0; # degrees, counter-clockwise
        reload_time = -1; # seconds between reloading, 0 to reload with SIGUSR2
        #    reload_cmd = ; # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F
        position = scaleArray [
          0
          200
        ];
        halign = "center";
        valign = "center";
      };
    };
  };
}
