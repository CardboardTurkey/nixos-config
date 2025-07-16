{
  pkgs,
  osConfig,
  lib,
  ...
}:
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

          key <AC06> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ h, H, Left ]
          };
          key <AC07> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ j, J, Down ]
          };
          key <AC08> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ k, K, Up ]
          };
          key <AC09> {
              type[Group1]="SHIFT_HYPER_LEVEL3",
              symbols[Group1] = [ l, L, Right ]
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

  launchTerminal = pkgs.writeScript "launch_terminal" ''
    hyprctl dispatch workspace 1 &&\
    test -n "$(\
      hyprctl clients -j\
      | ${pkgs.dasel}/bin/dasel -r json -w - 'all().filter(equal(workspace.id,1)).filter(equal(class,kitty))'\
    )" || hyprctl keyword exec '[workspace 1] ${pkgs.${osConfig.emulator}}/bin/${osConfig.emulator}' '';

in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      # source = [ "${hyde}/Configs/.config/hypr/animations/animations-me-1.conf" ];
      bind = [
        "SUPER, Return, exec, ${launchTerminal}"
        "MOD3, Return, exec, ${pkgs.${osConfig.emulator}}/bin/${osConfig.emulator}&"

        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mainMod, Q, exec, ${pkgs.${osConfig.emulator}}/bin/${osConfig.emulator}"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
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
        "$mainMod, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"
        "$mainMod, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.9}')"
        "$mainMod SHIFT, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor 1"
        "$mainMod SHIFT, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor 1"
        "$mainMod SHIFT, minus, exec, hyprctl -q keyword cursor:zoom_factor 1"
        "$mainMod SHIFT, KP_SUBTRACT, exec, hyprctl -q keyword cursor:zoom_factor 1"
        "$mainMod SHIFT, 0, exec, hyprctl -q keyword cursor:zoom_factor 1"

        "MOD3, right, workspace, e+1"
        "MOD3, left, workspace, e-1"

        # full screen
        "SUPER, F, fullscreen"

        # Brightness raise
        ", XF86MonBrightnessUp, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness raise"
        # Brightness lower
        ", XF86MonBrightnessDown, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness lower"

        # random bindings
        ''$mainMod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -''
        "SUPER, X, exec, ${pkgs.${osConfig.emulator}}/bin/${osConfig.emulator} --class clipse -e ${pkgs.clipse}/bin/clipse"
        "SUPER, T, exec, ${lib.getExe pkgs.firefox} --new-window https://pad.kiran.smoothbrained.co.uk/EyFToF4NTzCOEvTaqTVHGw"
      ];

      binde = [
        "$mainMod, equal, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"
        "$mainMod, minus, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.9}')"
        "$mainMod, KP_ADD, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"
        "$mainMod, KP_SUBTRACT, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.9}')"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        # switches
        '',switch:on:Lid Switch,exec, hyprctl keyword monitor "eDP-1, disable"''
        '',switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1, preferred, auto, 1"''
      ];

      input = {
        kb_layout = "";
        # kb_options = ctrl:swapcaps_hyper
        kb_file = "${myCustomLayout}";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 4;
        gaps_out = osConfig.gapsOut;
        border_size = 2;
        "col.active_border" = "$surface0 $accent 45deg";
        "col.inactive_border" = "$surface0";

        layout = "dwindle";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = osConfig.cornerRadius;
        blur = {
          enabled = true;
          size = 12;
          passes = 5;
          new_optimizations = true;
          xray = false;
        };

        shadow = {
          enabled = true;
          color = "rgba(1a1a1aee)";
          range = 4;
          render_power = 3;
        };
      };
      # https://github.com/prasanthrangan/hyprdots/blob/47572bbcac007d1d51e9251debb5dad5df4bbbb9/Configs/.config/hypr/animations/animations-diablo-1.conf
      animations = {
        enabled = true;
        bezier = [
          "default, 0.05, 0.9, 0.1, 1.05"
          "wind, 0.05, 0.9, 0.1, 1.05"
          "overshot, 0.13, 0.99, 0.29, 1.08"
          "liner, 1, 1, 1, 1"
          "bounce, 0.4, 0.9, 0.6, 1.0"
          "snappyReturn, 0.4, 0.9, 0.6, 1.0"
          "slideInFromRight, 0.5, 0.0, 0.5, 1.0"
        ];
        animation = [
          "windows, 1, 5,  snappyReturn, slidevert"
          "windowsIn, 1, 5, snappyReturn, slidevert right"
          "windowsOut, 1, 5, snappyReturn, slide"
          "windowsMove, 1, 6, bounce, slide"
          "layersOut, 1, 5, bounce, slidevert right"
          "fadeIn, 1, 10, default"
          "fadeOut, 1, 10, default"
          "fadeSwitch, 1, 10, default"
          "fadeShadow, 1, 10, default"
          "fadeDim, 1, 10, default"
          "fadeLayers, 1, 10, default"
          "workspaces, 1, 7, overshot, slide"
          "border, 1, 50, liner"
          "layers, 1, 4, bounce, slidevert right"

        ] ++ (if osConfig.hostname == "Osprey" then [ "borderangle, 1, 30, liner, loop" ] else [ ]);
      };
      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
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

      windowrulev2 = [
        "opacity 1.0 0.7, title:^(.*)$"
        "float,title:^(Firefox — Sharing Indicator)$"
        "float,title:^(Password Required - Mozilla Firefox)$"

        # Assign program to workspace
        # windowrule=workspace 1 silent,kitty
        "workspace 2, class:codium"
        "workspace 2, class:codium-url-handler"
        "workspace 3, class:firefox"
        "workspace 3, class:firefox-default"
        "workspace 4, class:thunderbird"
        "workspace 5, class:quassel"
        "workspace 5, class:signal"
        "workspace 6, class:steam"
        "workspace 7, class:Gimp"
        "workspace 8, title:btop"

        "float,class:(clipse)"
        "size 622 652,class:(clipse)"

        "float,title:(Picture-in-Picture)"
        "pin,title:(Picture-in-Picture)"
        "opacity 1.0,title:(Picture-in-Picture)"
        "size 533 300,title:(Picture-in-Picture)"
        "move 100%-w-40 100%-w-40,title:(Picture-in-Picture)"

        "float,class:(com.saivert.pwvucontrol)"
        "size 1200 600,class:(com.saivert.pwvucontrol)"

        "idleinhibit fullscreen, class:^(*)$"
        "idleinhibit fullscreen, title:^(*)$"
        "idleinhibit fullscreen, fullscreen:1"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mainMod" = "SUPER";

      exec-once = [
        "${pkgs.clipse}/bin/clipse -listen"
        "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular"
      ];

      # change monitor to hires, the last argument is the scale factor
      monitor = [
        ",highres,auto,1"
        "HDMI-A-1,preferred,0x0,2"
        "FALLBACK,1920x1080@60,auto,1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      # toolkit-specific scale
      env = [
        "GDK_SCALE,1"
        "XCURSOR_SIZE,16"
      ];

      # layers
      layerrule = [
        "blur,notifications"
        "ignorezero,notifications"
        "noanim,selection"
      ];
    };
  };
}
