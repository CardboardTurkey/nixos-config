{
  pkgs,
  osConfig,
  config,
  lib,
  ...
}:
let
  themeColours = builtins.fromJSON (
    builtins.readFile (
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Jas-SinghFSU/HyprPanel/refs/heads/master/themes/catppuccin_${osConfig.flavour}.json";
        hash = "sha256-RFherVDDt4Lqur/QGmgdWulyokDWpgxBex8dUYa32v8=";
      }
    )
  );
in
{
  wayland.windowManager.hyprland.settings.bind = [
    ", XF86AudioRaiseVolume, exec, ${pkgs.hyprpanel}/bin/hyprpanel vol +1"
    ", XF86AudioLowerVolume, exec, ${pkgs.hyprpanel}/bin/hyprpanel vol -1"
    ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ", XF86KbdBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} set 5%-"
    ", XF86KbdBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} set 5%+"
  ];

  sops.secrets."weatherapi.com" = { };

  programs.hyprpanel = {
    enable = true;
    settings = lib.recursiveUpdate themeColours {
      theme = {
        bar = {
          buttons = {
            enableBorders = true;
            workspaces = {
              enableBorder = false;
              fontSize = osConfig.fontSizeMedium;
            };
            radius = "${toString (osConfig.cornerRadius * 1.3)}px";
            padding_x = "0.7rem";
            y_margins = "0px";
            borderSize = "0.2em";
            background_hover_opacity = 70;
          };
          menus = {
            slider = {
              slider_radius = "10em";
              progress_radius = "10em";
            };
            switch = {
              slider_radius = "10em";
              radius = "10em";
            };
            border = {
              radius = "${toString (osConfig.cornerRadius * 1.3)}px";
              size = "0.22em";
            };
            card_radius = "${toString (osConfig.cornerRadius * 1.3)}px";
            monochrome = false;
            opacity = 100;
            dashboard.profile.radius = "${toString (osConfig.cornerRadius * 1.3)}px";
          };
          transparent = true;
          floating = true;
          border_radius = "${toString (osConfig.cornerRadius * 1.3)}px";
          margin_sides = "${toString (osConfig.gapsOut - 5)}px";
          outer_spacing = "0em";
          spacing = "5px";

        };
        osd = {
          radius = "10em";
          margins = "0px 0px 70px 0px";
          orientation = "horizontal";
          location = "bottom";
          border.size = "3px";
        };

        notification.border_radius = "${toString osConfig.gapsOut}";

        font = {
          size = osConfig.fontSizeMedium;
          weight = 500;
          # name = "SF Pro Display";
        };
      };

      terminal = osConfig.emulator;

      bar = {
        layouts = {
          "0" = {
            left = [
              "dashboard"
              "workspaces"
              "windowtitle"
              "media"
            ];
            middle = [
              "clock"
            ];
            right =
              [
                "cava"
                "volume"
                "network"
                "bluetooth"
              ]
              # Include battery if not desktop
              ++ (if (osConfig.hostname != "Osprey") then [ "battery" ] else [ ])
              ++ [
                "hypridle"
                "systray"
                "notifications"
                "power"
              ];
          };
        };
        clock = {
          format = "%a %b %d     %H:%M:%S";
          icon = "";
        };
        windowtitle.title_map = [
          [
            "webcord"
            ""
            "Discord"
          ]
          [
            "codium"
            ""
            "Codium"
          ]
          [
            "signal"
            ""
            "Signal"
          ]
        ];
        systray.customIcons = {
          chrome_status_icon_1 = {
            "icon" = "";
            "color" = "${osConfig.theme.subtext1.hex}";
          };
        };
        systray.ignore = [
          "blueman"
          "nm-applet"
        ];
        volume = {
          scrollUp = "hyprpanel vol +1";
          scrollDown = "hyprpanel vol -1";
        };
        workspaces = {
          showAllActive = true;
          spacing = 1;
          workspaceMask = false;
          monitorSpecific = false;
          showWsIcons = true;
          showApplicationIcons = true;
          numbered_active_indicator = "underline";
          applicationIconOncePerWorkspace = true;
          applicationIconMap = {
            "[cC]odium" = "";
            "[wW]ebcord" = "";
            "[sS]ignal" = "";
          };

        };
        media = {
          truncation_size = 30;
          rightClick = "${lib.getExe pkgs.playerctl} play-pause";
          show_active_only = true;
        };
        customModules = {
          power.icon = "";
          cava.showActiveOnly = true;
        };
        launcher.icon = "";
        bluetooth.label = true;
      };

      menus = {
        clock = {
          time.military = true;
          weather = {
            unit = "metric";
            key = config.sops.secrets."weatherapi.com".path;
            location = "Manchester";
          };
        };
        dashboard = {
          powermenu.avatar = {
            image = pkgs.fetchurl {
              url = "https://lh3.googleusercontent.com/pw/AP1GczOwu1Gthp8Ue48RclkldBcvFU0cgIgLnB3S_KpwOvhH0geYeAyyA5uLSJw9KEh_DgJ_I2euJeoJlUOHczHH2yGzWQkXdmRsCuS70OZu4wWhbz2BouVDeSYnDfDU_iENHljtIo7kaMbkcTBkrV5tkGAFWg=w640-h640-s-no";
              hash = "sha256-lZgmp7KMIhOl5/IxfORd7Kb3V5sLH2darR6a+HgYTVM=";
            };
            name = "${config.home.username}";
          };
          directories.enable = false;
          shortcuts.enabled = false;
          controls.enabled = true;
        };
        transition = "crossfade";
        volume.raiseMaximumVolume = false;
      };
      wallpaper.pywal = false;
      hyprpanel.restartCommand = "hyprpanel q; hyprpanel";
      scalingPriority = "hyprland";

      # Customise colours
      "theme.bar.buttons.modules.hypridle.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.hypridle.text" = osConfig.theme.flamingo.hex;
      "theme.bar.buttons.modules.hypridle.icon" = osConfig.theme.flamingo.hex;
      "theme.bar.menus.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.dashboard.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.dashboard.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.dashboard.icon" = osConfig.theme.sky.hex;
      "theme.bar.buttons.workspaces.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.workspaces.active" = osConfig.theme.${osConfig.accent}.hex;
      "theme.bar.buttons.workspaces.numbered_active_underline_color" =
        osConfig.theme.${osConfig.accent}.hex;
      "theme.bar.buttons.workspaces.occupied" = osConfig.theme.overlay2.hex;
      "theme.bar.buttons.workspaces.available" = osConfig.theme.overlay2.hex;
      "theme.bar.menus.menu.dashboard.powermenu.confirmation.border" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.notifications.border" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.clock.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.battery.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.bluetooth.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.network.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.volume.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.media.border.color" = osConfig.theme.surface0.hex;
      "theme.notification.border" = osConfig.theme.surface0.hex;
      "theme.bar.menus.popover.border" = osConfig.theme.surface0.hex;
      "theme.bar.menus.menu.power.border.color" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.power.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.cava.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.weather.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.kbLayout.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.storage.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.cpu.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.modules.ram.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.notifications.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.clock.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.clock.text" = osConfig.theme.rosewater.hex;
      "theme.bar.buttons.clock.icon" = osConfig.theme.rosewater.hex;
      "theme.bar.buttons.battery.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.systray.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.bluetooth.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.network.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.network.text" = osConfig.theme.pink.hex;
      "theme.bar.buttons.network.icon" = osConfig.theme.pink.hex;
      "theme.bar.buttons.volume.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.volume.text" = osConfig.theme.lavender.hex;
      "theme.bar.buttons.volume.icon" = osConfig.theme.lavender.hex;
      "theme.bar.buttons.media.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.media.text" = osConfig.theme.lavender.hex;
      "theme.bar.buttons.media.icon" = osConfig.theme.lavender.hex;
      "theme.bar.buttons.windowtitle.border" = osConfig.theme.surface0.hex;
      "theme.bar.buttons.windowtitle.text" = osConfig.theme.rosewater.hex;
      "theme.bar.buttons.windowtitle.icon" = osConfig.theme.rosewater.hex;
    };
  };
}
