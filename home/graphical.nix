{ config, lib, pkgs, ... }:

let

  codium-extensions = (with pkgs.vscode-extensions; [
        # bbenoist.Nix
        jnoortheen.nix-ide
        arcticicestudio.nord-visual-studio-code
        ms-python.python
        matklad.rust-analyzer
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }
    ];

  # i3
  mod = "Mod4";
  alt = "Mod1";
  ws-term = "1";
  ws-code = "2";
  ws-fire = "3";
  ws-spot = "4";
  ws-pdf  = "5";
  ws-mail = "6";
  ws-img  = "7";
  ws-irc  = "8";
  ws-chrm = "9";

in

{
  # Needed by gtk?
  programs.dconf.enable = true;

  # For udev rule
  services.autorandr.enable = true;

  home-manager.users.kiran = { pkgs, ... }: {
    # home.packages = [ pkgs.atool pkgs.httpie ];
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.zafiro-icons;
        name = "Zafiro";
      };
      font = {
        name = "DejaVu Sans 12";
      };
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      gtk3.extraCss = ''
        .termite { 
          padding:25px;
          padding-bottom: 5px; 
        }
      '';
    };
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;
        bars = [ ];
        fonts = {
          names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
          style = "Bold Semi-Condensed";
          size = 11.0;
        };
        keybindings = lib.mkOptionDefault {
          "XF86AudioMute"         = "exec amixer set Master toggle";
          "XF86AudioLowerVolume"  = "exec amixer set Master 4%-";
          "XF86AudioRaiseVolume"  = "exec amixer set Master 4%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 4%-";
          "XF86MonBrightnessUp"   = "exec brightnessctl set 4%+";
          "${mod}+Control+Return" = "exec termite";
          "${mod}+Return"         = "workspace 1; exec pgrep termite || termite";
          "${mod}+Control+space"  = "focus mode_toggle";
          "${mod}+Control+Left"   = "workspace prev";
          "${mod}+Control+Right"  = "workspace next";
          "${mod}+${alt}+Down"    = "move workspace to output down";
          "${mod}+${alt}+Up"      = "move workspace to output up";
          "${mod}+${alt}+Left"    = "move workspace to output left";
          "${mod}+${alt}+Right"   = "move workspace to output right";
        };
        assigns = {
          "${ws-code}" = [{ class="VSCodium";}];
          "${ws-fire}" = [{ class="Firefox";}];
          "${ws-chrm}" = [{ class="Google-chrome";}];
          "${ws-spot}" = [{ class="spotify";}];
          "${ws-pdf}"  = [{ class="Evince";}];
          "${ws-mail}" = [{ class="Mail";}];
          "${ws-img}"  = [{ class="viewnior";}];
          "${ws-irc}"  = [{ class="quasselclient";}];        
        };
        startup = [
          { command = "nitrogen --restore"; always = true; notification = false; }
        ];
      }; 
      extraConfig = ''
        for_window [class="Mail"] focus
        for_window [class="vscodium"] focus
        for_window [class="firefox"] focus
        for_window [class="viewnior"] focus
        for_window [class="Evince"] focus   

        default_border pixel 1
        default_floating_border pixel 1
      '';
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = codium-extensions;
      userSettings = {
        "workbench.colorTheme" = "Nord";
        "editor.fontSize" = 20;
        "editor.fontFamily" = "'DejaVu Sans Mono', 'Font Awesome 5 Brands', 'Font Awesome 5 Free', 'Font Awesome 5 Free Solid'";
      };
    };
    xdg = {
      configFile."betterlockscreenrc".source = ./config/betterlockscreenrc;
    };
    services.betterlockscreen ={
      enable = true;
      arguments = [ "dim" ];
    };
    services.screen-locker = {
      enable = true;
    };
    programs.autorandr = {
      enable = true;
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
          # hooks.postswitch = builtins.readFile ./work-postswitch.sh;
        };
        "work" = {
          fingerprint = {
            eDP-1 = "00ffffffffffff0009e5c90700000000011c0104a51e117802fb90955d59942923505400000001010101010101010101010101010101393780de703814403020360035ad1000001a2d2c80de703814403020360035ad1000001a000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e34380a0078";
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
        "hmdi2" = {
          fingerprint = {
            eDP-1 = "*";
            HDMI-2 = "*";
          };
          config = {
            eDP-1 = {
              enable = true;
              crtc = 0;
              position = "3840x1080";
              mode = "1920x1080";
              rate = "60.00";
            };
            HDMI-2 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "0x0";
              mode = "3840x2160";
              rate = "60.00";
            };
          };
        };
      };
    };
  };

}