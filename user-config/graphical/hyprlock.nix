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
        path = osConfig.pics.lock;
        blur_passes = 1;
        color = "$base";
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 1, 1, 0, 0"
          "easeInQuart, 0.5, 0, 0.75, 0"
        ];
        animation = [
          "fadeIn, 1, 5, easeInQuart"
          "fadeOut, 1, 5, easeInQuart"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "$peach";
          font_size = 90;
          font_family = "$font";
          position = scaleArray [
            0
            150
          ];
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
          color = "$peach";
          font_size = 25;
          font_family = "$font";
          position = scaleArray [
            0
            50
          ];
          halign = "center";
          valign = "center";
        }
      ];

      input-field = {
        monitor = "";
        size = scaleArray [
          300
          60
        ];
        outline_thickness = 3;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "$peach";
        inner_color = "$base";
        font_color = "$peach";
        fade_on_empty = true;
        placeholder_text = "";
        hide_input = false;
        check_color = "$accent";
        fail_color = "$red";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "$yellow";
        position = scaleArray [
          0
          (-47)
        ];
        halign = "center";
        valign = "center";
      };
    };
  };
}
