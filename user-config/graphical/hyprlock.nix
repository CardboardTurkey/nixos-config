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
        disable_loading_bar = false;
      };

      # BACKGROUND
      background = {
        monitor = "";
        path = osConfig.pics.lock;
      };
    };
  };
}
