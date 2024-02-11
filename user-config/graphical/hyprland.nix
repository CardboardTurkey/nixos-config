{ pkgs, config, lib, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  lock_cmd_flags = monitors: wallpaper: lib.strings.concatMapStrings (monitor: "--image=${monitor}:${wallpaper} ") monitors;
  lock_cmd = "${pkgs.swaylock}/bin/swaylock -f ${lock_cmd_flags config.dual_monitor_right config.wallpapers.dual.right} ${lock_cmd_flags config.dual_monitor_left config.wallpapers.dual.left} --image=${config.wallpapers.single}";

  monitor_off = pkgs.writeScript "monitor_off" ''
    if [[ `hyprctl monitors -j | ${pkgs.jq}/bin/jq length` -gt 1 ]] # || [[ `cat /sys/class/power_supply/AC/online` -ne 0 ]]
    then
      hyprctl keyword monitor "eDP-1, disable"
    fi'';

  # check ${pkgs.setxkbmap}/share/X11/xkb for default configs.
  myCustomLayout = pkgs.writeText "layout.xkb" ''
    xkb_keymap {
        xkb_keycodes  { include "evdev+aliases(qwerty)" };
        xkb_types     {
          include "complete"
          type "SHIFT_HYPER_LEVEL3" {
            modifiers = Shift+Mod3;
            map[None] = Level1;
            map[Shift] = Level2;
            map[Mod3] = Level3;
            level_name[Level1] = "Base";
            level_name[Level2] = "Shift";
            level_name[Level3] = "Hyper";
          };
          type "SHIFT_HYPER_LEVEL4" {
            modifiers = Shift+Mod3;
            map[None] = Level1;
            map[Shift] = Level2;
            map[Mod3] = Level3;
            map[Shift+Mod3] = Level4;
            level_name[Level1] = "Base";
            level_name[Level2] = "Shift";
            level_name[Level3] = "Hyper";
            level_name[Level3] = "Hyper Shift";
          };
          type "HYPER_LEVEL2" {
            modifiers = Mod3;
            map[None] = Level1;
            map[Mod3] = Level2;
            level_name[Level1] = "Base";
            level_name[Level2] = "Hyper";
          };
        };
        xkb_compat    { include "complete"  };
        xkb_symbols   { 
          include "pc+gb+inet(evdev)+terminate(ctrl_alt_bksp)"

          key <AC07> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ j, J, Left ]
          };
          key <AC08> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ k, K, Down ]
          };
          key <AC09> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ l, L, Up ]
          };
          key <AC10> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ semicolon, colon, Right ]
          };
          
          key <AB01> {
              type[Group1]="SHIFT_HYPER_LEVEL4",
              symbols[Group1] = [ z, Z, bar, backslash ]
          };

          key <UP> {
              type[Group1]="HYPER_LEVEL2",
              symbols[Group1] = [ Up, Home ]
          };
          key <DOWN> {
              type[Group1]="HYPER_LEVEL2",
              symbols[Group1] = [ Down, End ]
          };

          key <CAPS> {	[ Control_L ]	};
          key <AE02> { [ 2, at ] };
          key <AC11> { [ apostrophe, quotedbl ] };
          replace key <LCTL> {	[ Hyper_L ]	};
          modifier_map Control { <CAPS> };
          modifier_map Mod3    { <LCTL> };
        };
        xkb_geometry  { include "pc(pc104)" };
    };
  '';

  launchTerminal = pkgs.writeScript "launchterminal" ''
    hyprctl dispatch workspace 1 && hyprctl activewindow | ${pkgs.ripgrep}/bin/rg Alacritty || alacritty&disown'';

in
{

  environment.systemPackages = with pkgs; [
    pipewire # needed for screen sharing
    wireplumber # needed for screen sharing
    slurp
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    xwayland
  ];

  # from wiki.hyprland
  # Optional, hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services.swaylock = { };

  # services.udev.extraRules = "KERNEL==\"uinput\", GROUP=\"users\", MODE=\"0660\", OPTIONS+=\"static_node=uinput\"\n";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  home-manager.users.kiran = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable= true;
      extraConfig = ''
        bind = SUPER, Return, exec, ${launchTerminal}
        bind = MOD3, Return, exec, alacritty&
        # This is an example Hyprland config file.
        #
        # Refer to the wiki for more information.

        #
        # Please note not all available settings / options are set here.
        # For a full list, see the wiki
        #

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more

        # Execute your favorite apps at launch
        # exec-once = waybar & hyprpaper & firefox

        # Source a file (multi-file configs)
        # source = ~/.config/hypr/myColors.conf

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
            kb_layout = 
            # kb_options = ctrl:swapcaps_hyper
            kb_file = ${myCustomLayout}

            follow_mouse = 1

            touchpad {
                natural_scroll = false
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        }

        general {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = 4
            gaps_out = 10
            border_size = 2
            # col.active_border = rgba(${config.nord2}FF) rgba(${config.nord7}FF) 45deg
            col.active_border = rgba(${config.nord2}FF)
            col.inactive_border = rgba(${config.nord2}FF)

            layout = dwindle
        }

        decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 8
            blur {
              enabled = true
              size = 3
              passes = 3
              new_optimizations = true
              xray = false
            }

            drop_shadow = false
            shadow_range = 4
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
        }

        animations {
            enabled = true

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
            bezier = overshot, 0.05, 0.9, 0.1, 1.05
            bezier = smoothOut, 0.36, 0, 0.66, -0.56
            bezier = smoothIn, 0.25, 1, 0.5, 1

            animation = windows, 1, 5, overshot, slide
            animation = windowsOut, 1, 4, smoothOut, slide
            animation = windowsMove, 1, 4, default
            animation = border, 1, 10, default
            animation = fade, 1, 10, smoothIn
            animation = fadeDim, 1, 10, smoothIn
            animation = workspaces, 1, 6, default
        }

        dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true # you probably want this
        }

        master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = true
        }

        gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = true
            workspace_swipe_min_speed_to_force = 0
            workspace_swipe_cancel_ratio = 0.1
        }

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        device:epic-mouse-v1 {
            sensitivity = -0.5
        }

        misc {
          mouse_move_enables_dpms = true
          # key_press_enables_dpms = true
          animate_manual_resizes = true
          animate_mouse_windowdragging = true
          focus_on_activate = true
        }

        # Example windowrule v1
        # windowrule = float, ^(alacritty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(alacritty)$,title:^(alacritty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        windowrule = opacity 1.0 0.7, title:^(.*)$
        windowrule = float,title:^(Firefox — Sharing Indicator)$
        windowrule = float,title:^(Password Required - Mozilla Firefox)$

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        $mainMod = SUPER

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        bind = $mainMod, Q, exec, alacritty
        bind = $mainMod, C, killactive,
        bind = $mainMod, M, exit,
        bind = $mainMod, E, exec, dolphin
        bind = $mainMod, V, togglefloating,
        bind = $mainMod, R, exec, wofi --show drun
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle

        # Move focus with mainMod + arrow keys
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d

        # Switch workspaces with mainMod + [0-9]
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        # Move workspace to monitor
        bind=$mainMod ALT, left, movecurrentworkspacetomonitor, l
        bind=$mainMod ALT, right, movecurrentworkspacetomonitor, r
        bind=$mainMod ALT, up, movecurrentworkspacetomonitor, u
        bind=$mainMod ALT, down, movecurrentworkspacetomonitor, d

        # Scroll throurightgh existing workspaces with mainMod + scroll
        bind = MOD3, right, workspace, e+1
        bind = MOD3, left, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        # full screen
        bind = SUPER, F, fullscreen

        # disable primary buffer
        exec-once = wl-paste -p --watch wl-copy -pc

        # Assign program to workspace
        # windowrule=workspace 1 silent,kitty
        windowrule = workspace 2, codium-url-handler
        windowrule = workspace 3, firefox
        windowrule = workspace 3, firefox-default
        windowrule = workspace 4, thunderbird
        windowrule = workspace 5, quassel
        windowrule = workspace 5, Signal
        windowrule = workspace 6, steam
        windowrule = workspace 7, Gimp

        # random bindings
        bind = , XF86AudioMute, exec, amixer set Master toggle
        bind = , XF86AudioLowerVolume, exec, amixer set Master 5%-
        bind = , XF86AudioRaiseVolume, exec, amixer set Master 5%+
        bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
        bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
        bind = $mainMod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
        bind = $mainMod, L, exec, ${lock_cmd}

        # switches
        bindl = ,switch:on:Lid Switch,exec,${monitor_off}
        bindl = ,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, preferred, auto, 1"

        # wallpaper
        exec = ${pkgs.wbg}/bin/wbg ${config.wallpapers.single}&

        # highres xwayland
        # change monitor to hires, the last argument is the scale factor
        monitor=,highres,auto,1

        # sets xwayland scale
        exec-once=${pkgs.xorg.xprop}/bin/xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 24c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1

        # toolkit-specific scale
        env = GDK_SCALE,1
        env = XCURSOR_SIZE,16

        # layers
        layerrule = blur,rofi
        layerrule = blur,notifications
        layerrule = ignorezero,notifications

        # Bar reservation
        # monitor=,addreserved,0,0,60,0
      '';
    };
    systemd.user.services.swayidle = {
      Unit = {
        Description = "Idle manager for Wayland";
        Documentation = "man:swayidle(1)";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        # swayidle executes commands using "sh -c", so the PATH needs to contain a shell.
        Environment = [ "PATH=${lib.makeBinPath [ pkgs.bash pkgs.hyprland ]}" ];
        ExecStart =
          "${pkgs.swayidle}/bin/swayidle -d -w timeout 300 \'${lock_cmd}\' timeout 330 \'${pkgs.hyprland}/bin/hyprctl dispatch dpms off\' resume \'${pkgs.hyprland}/bin/hyprctl dispatch dpms on\' after-resume \'${pkgs.hyprland}/bin/hyprctl dispatch dpms on\' before-sleep \'${lock_cmd}\'";
      };
      Install = { WantedBy = [ "hyprland-session.target" ]; };
    };
    # services.swayidle = {
    #   enable = true;
    #   systemdTarget = "hyprland-session.target";
    #   timeouts = [
    #     { timeout = 2; command = "'${lock_cmd}'"; }
    #     {
    #       timeout = 4;
    #       command = "'hyprctl dispatch dpms off'";
    #       resumeCommand = "'hyprctl dispatch dpms on'";
    #     }
    #   ];
    #   events = [
    #     {
    #       event = "after-resume";
    #       command = "'hyprctl dispatch dpms on'";
    #     }
    #     {
    #       event = "before-sleep";
    #       command = "${lock_cmd}";
    #     }
    #   ];
    # };
  };
}
