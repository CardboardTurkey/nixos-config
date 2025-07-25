{ config, lib, ... }:

{
  # For udev rule
  # services.autorandr.enable = true;

  home-manager.users.kiran =
    { pkgs, ... }:
    {

      xsession.windowManager.i3 = {
        config = {
          keybindings = lib.mkOptionDefault { "Mod5+X" = "exec autorandr --change"; };
          startup = [
            {
              command = "autorandr --change";
              always = true;
            }
          ];
        };
      };
    };

  services.autorandr = {
    enable = true;
    hooks.postswitch = {
      "background" = "feh --bg-fill $HOME/.background-image";
    };
    profiles = {
      "laptop" = {
        fingerprint = {
          eDP-1 = "*";
        };
        config = {
          eDP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "hdmi_4k" = {
        fingerprint = {
          eDP-1 = "${config.edp1}";
          HDMI-2 = "00ffffffffffff0005e3792813070000211a0103803e22782a08a5a2574fa2280f5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e80302035006d552100001aa36600a0f0701f80302035006d552100001a000000fc00553238373947360a2020202020000000fd0017501e8c3c000a20202020202001b4020333f14c9004031f1301125d5e5f606123090707830100006d030c001000397820006001020367d85dc401788003e30f000c011d007251d01e206e2855006d552100001e8c0ad08a20e02d10103e96006d55210000184d6c80a070703e8030203a006d552100001aa36600a0f0701f80302035006d552100001a00000000ea";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          HDMI-2 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "60.00";
            dpi = 192;
          };
        };
      };
      "any_hmdi2_edp" = {
        fingerprint = {
          eDP-1 = "*";
          HDMI-2 = "*";
        };
        config = {
          eDP-1 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          HDMI-2 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp1_edp" = {
        fingerprint = {
          eDP-1 = "${config.edp1}";
          DP-1 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp1_only" = {
        fingerprint = {
          DP-1 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp1-1_edp" = {
        fingerprint = {
          eDP-1 = "${config.edp1}";
          DP-1-1 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp1-1_only" = {
        fingerprint = {
          DP-1-1 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp2-1_edp" = {
        fingerprint = {
          eDP-1 = "${config.edp1}";
          DP-2-1 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-2-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp2-1_only" = {
        fingerprint = {
          DP-2-1 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-2-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp2_only" = {
        fingerprint = {
          DP-2 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-2 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp2_edp" = {
        fingerprint = {
          eDP-1 = "${config.edp1}";
          DP-2 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-2 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "dp2_edp_both_on" = {
        fingerprint = {
          eDP-1 = "*";
          DP-2 = "*";
        };
        config = {
          eDP-1 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-2 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "any_dp11_dp13_off_edp" = {
        fingerprint = {
          eDP-1 = "*";
          DP-1-1 = "*";
          DP-1-3 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1-1 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-1-3 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "any_dp11_dp13" = {
        fingerprint = {
          DP-1-1 = "*";
          DP-1-3 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1-1 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-1-3 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "any_dp21_dp23_off_edp" = {
        fingerprint = {
          eDP-1 = "*";
          DP-2-1 = "*";
          DP-2-3 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-2-1 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-2-3 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "any_dp21_dp23" = {
        fingerprint = {
          DP-2-1 = "*";
          DP-2-3 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-2-1 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-2-3 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "any_dp1_hdmi2_off_edp" = {
        fingerprint = {
          eDP-1 = "*";
          DP-1 = "*";
          HDMI2 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          HDMI-2 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
      "any_dp1_hdmi2" = {
        fingerprint = {
          DP-1 = "*";
          HDMI2 = "*";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          HDMI-2 = {
            enable = true;
            crtc = 0;
            position = "1920x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          DP-1 = {
            enable = true;
            crtc = 1;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
          };
        };
      };
    };
  };
}
