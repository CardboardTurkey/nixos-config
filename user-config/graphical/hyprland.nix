{ pkgs, config, ... }:
let
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

  launchTerminal = pkgs.writeScript "launchterminal"
    "hyprctl clients -j | ${pkgs.dasel}/bin/dasel -r json 'all().filter(equal(workspace.id,1)).filter(equal(class,Alacritty))' | xargs test -n && { ${pkgs.alacritty}/bin/alacritty&disown && sleep .1 && hyprctl dispatch movetoworkspace 1; } || hyprctl dispatch workspace 1";

in {

  environment.systemPackages = with pkgs; [
    pipewire # needed for screen sharing
    wireplumber # needed for screen sharing
    slurp
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
  ];

  # from wiki.hyprland
  # Optional, hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services.swaylock = { };

  # services.udev.extraRules = "KERNEL==\"uinput\", GROUP=\"users\", MODE=\"0660\", OPTIONS+=\"static_node=uinput\"\n";

  programs.hyprland = { enable = true; };
  home-manager.users.kiran = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        bind = [
          "SUPER, Return, exec, ${launchTerminal}"
          "MOD3, Return, exec, alacritty&"
          "MOD3, PERIOD, exec, ${pkgs.bemoji}/bin/bemoji -n"

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "$mainMod, Q, exec, alacritty"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, dolphin"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, wofi --show drun"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, J, togglesplit, # dwindle"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Move workspace to monitor
          "$mainMod ALT, left, movecurrentworkspacetomonitor, l"
          "$mainMod ALT, right, movecurrentworkspacetomonitor, r"
          "$mainMod ALT, up, movecurrentworkspacetomonitor, u"
          "$mainMod ALT, down, movecurrentworkspacetomonitor, d"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod, S, movetoworkspace, +0"
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod, S, movetoworkspace, special:magic"
          "$mainMod, S, togglespecialworkspace, magic"

          # Scroll throurightgh existing workspaces with mainMod + scroll
          "MOD3, right, workspace, e+1"
          "MOD3, left, workspace, e-1"

          # full screen
          "SUPER, F, fullscreen"

          # random bindings
          ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ''
            $mainMod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -''
          "$mainMod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
          "SUPER, X, exec, alacritty --class clipse -e ${pkgs.clipse}/bin/clipse"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindl = [
          # switches
          ''
            ,switch:on:Lid Switch,exec, hyprctl keyword monitor "eDP-1, disable"''
          ''
            ,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, preferred, auto, 1"''
        ];

        input = {
          kb_layout = "";
          # kb_options = ctrl:swapcaps_hyper
          kb_file = "${myCustomLayout}";

          follow_mouse = 1;

          touchpad = { natural_scroll = false; };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 4;
          gaps_out = 10;
          border_size = 2;
          # col.active_border = rgba(${config.nord2}FF) rgba(${config.nord7}FF) 45deg
          "col.active_border" = "rgba(${config.nord2}FF)";
          "col.inactive_border" = "rgba(${config.nord2}FF)";

          layout = "dwindle";
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 8;
          blur = {
            enabled = true;
            size = 3;
            passes = 3;
            new_optimizations = true;
            xray = false;
          };

          drop_shadow = false;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };
        animations = {
          enabled = true;

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = [
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
          ];

          animation = [
            "windows, 1, 5, overshot, slide"
            "windowsOut, 1, 4, smoothOut, slide"
            "windowsMove, 1, 4, default"
            "border, 1, 10, default"
            "fade, 1, 10, smoothIn"
            "fadeDim, 1, 10, smoothIn"
            "workspaces, 1, 6, default"
          ];
        };
        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile =
            true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          # new_status = slave
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true;
          workspace_swipe_min_speed_to_force = 0;
          workspace_swipe_cancel_ratio = 0.1;
        };
        misc = {
          mouse_move_enables_dpms = true;
          # key_press_enables_dpms = true
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          focus_on_activate = true;
        };

        # Example windowrule v1
        # windowrule = float, ^(alacritty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(alacritty)$,title:^(alacritty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
        windowrule = [
          "opacity 1.0 0.7, title:^(.*)$"
          "float,title:^(Firefox — Sharing Indicator)$"
          "float,title:^(Password Required - Mozilla Firefox)$"

          # Assign program to workspace
          # windowrule=workspace 1 silent,kitty
          "workspace 2, codium-url-handler"
          "workspace 3, firefox"
          "workspace 3, firefox-default"
          "workspace 4, thunderbird"
          "workspace 5, quassel"
          "workspace 5, Signal"
          "workspace 6, steam"
          "workspace 7, Gimp"
        ];

        windowrulev2 = [
          "float,class:(clipse)"
          "size 622 652,class:(clipse)"
          "float,class:(com.saivert.pwvucontrol)"
          "size 1200 600,class:(com.saivert.pwvucontrol)"
        ];

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        "$mainMod" = "SUPER";

        exec-once = [
          "${pkgs.clipse}/bin/clipse -listen"
          "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular"
        ];

        exec = [
          # wallpaper
          "${pkgs.wbg}/bin/wbg ${config.wallpapers.single}&"
        ];

        # highres xwayland
        # change monitor to hires, the last argument is the scale factor
        monitor = [ ",highres,auto,1" "HDMI-A-1,preferred,0x0,2" ];

        # toolkit-specific scale
        env = [ "GDK_SCALE,1" "XCURSOR_SIZE,16" ];

        # layers
        layerrule =
          [ "blur,rofi" "blur,notifications" "ignorezero,notifications" ];

      };
    };
  };
}
