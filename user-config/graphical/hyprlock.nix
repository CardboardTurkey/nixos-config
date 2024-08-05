{ config, lib, ... }:

let
  scaleArray = array:
    lib.concatStringsSep ", "
    (map (x: toString (x * config.monitor_scale)) array);
in {
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  home-manager.users.kiran = {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd =
            "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd =
            "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [

          {
            timeout = 300; # 5min
            on-timeout =
              "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5min
            on-timeout =
              "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume =
              "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
        ];
      };
    };
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          # pam_module = "login";
          disable_loading_bar = false;
        };

        background = {
          monitor = "";
          path = config.wallpapers.single;
          blur_passes = 3; # 0 disables blurring
          blur_size = 3;
        };

        input-field = {
          monitor = "";
          size = scaleArray [ 200 50 ];
          outline_thickness = config.monitor_scale * 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rounding =
            -1; # -1 default circle, -2 follow input-field rounding
          outer_color = "rgb(${config.nord3})";
          inner_color = "rgb(${config.nord4})";
          font_color = "rgb(${config.nord0})";
          fade_on_empty = true;
          fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
          placeholder_text =
            "<i>the way is shut</i>"; # Text rendered in the input box when it's empty.
          hide_input = false;
          rounding = -1; # -1 means complete rounding (circle/oval)
          check_color = "rgb(${config.nord12})";
          fail_color =
            "rgb(${config.nord11})"; # if authentication failed, changes outer_color and fail message color
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
          fail_transition =
            300; # transition time in ms between normal outer_color and fail_color
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color =
            -1; # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false; # change color if numlock is off
          swap_font_color = false; # see below
          position = scaleArray [ 0 (builtins.fromJSON "-20") ];
          halign = "center";
          valign = "center";
        };

        label = [{
          monitor = "";
          #clock
          text = ''cmd[update:1000] echo "$TIME"'';
          color = "rgb(${config.nord5})";
          font_size = config.monitor_scale * 55;
          font_family = "DejaVuSansM Nerd Font";
          position =
            scaleArray [ (builtins.fromJSON "-100") (builtins.fromJSON "-40") ];
          halign = "right";
          valign = "bottom";
          shadow_passes = 5;
          shadow_size = config.monitor_scale * 10;
        }
        # {
        #   monitor = "";
        #   text = "$USER";
        #   color = "rgb(${config.nord5})";
        #   font_size = config.monitor_scale * 20;
        #   font_family = "DejaVuSansM Nerd Font";
        #   position = scaleArray [ (builtins.fromJSON "-100") 160 ];
        #   halign = "right";
        #   valign = "bottom";
        #   shadow_passes = 5;
        #   shadow_size = config.monitor_scale * 10;
        # }
          ];

        image = {
          monitor = "";
          path = config.wallpapers.single;
          size = config.monitor_scale * 280; # lesser side if not 1:1 ratio
          rounding = -1; # negative values mean circle
          border_size = config.monitor_scale * 4;
          border_color = "rgb(${config.nord6})";
          rotate = 0; # degrees, counter-clockwise
          reload_time =
            -1; # seconds between reloading, 0 to reload with SIGUSR2
          #    reload_cmd = ; # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F
          position = scaleArray [ 0 200 ];
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
