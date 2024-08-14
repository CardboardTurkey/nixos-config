{ pkgs, ... }:
let bar_cmd = "${pkgs.eww-wayland}/bin/eww open bar";
in {
  home-manager.users.kiran = { pkgs, ... }: {
    services.kanshi = {
      systemdTarget = "hyprland-session.target";
      enable = true;
      profiles = {
        undocked = {
          # exec = bar_cmd;
          outputs = [{
            criteria = "eDP-1";
            status = "enable";
            # scale = 1.0;
            # position = "0,0";
            # mode= "1920x1080@60Hz";
          }];
        };
        eDP1_DP1 = {
          # exec = bar_cmd;
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-1";
              status = "enable";
              # scale = 1.0;
              # position = "0,0";
              # mode= "1920x1080@60Hz";
            }
          ];
        };
      };
    };

  };
}
