{
  config,
  lib,
  pkgs,
  ...
}:

let

  # i3
  mod = "${config.i3_mod}";
  alt = "Mod1";
  ws-term = "1";
  ws-code = "2";
  ws-fire = "3";
  ws-spot = "4";
  ws-pdf = "5";
  ws-mail = "6";
  ws-irc = "7";
  ws-stm = "8";
  ws-gimp = "9";

in
{

  environment.systemPackages = with pkgs; [
    # For swapping keys
    xdotool
  ];

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeter.enable = true;
      };
    };
    desktopManager = {
      wallpaper = {
        mode = "fill";
      };
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  home-manager.users.kiran =
    { pkgs, ... }:
    {
      xsession.windowManager.i3 = {
        enable = true;
        config = {
          modifier = mod;
          bars = [ ];
          fonts = {
            names = [ "DejaVuSansMono Nerd Font" ];
            style = "Bold Semi-Condensed";
            size = config.fontSizeSmall;
          };
          keybindings = lib.mkOptionDefault {
            "${mod}+Control+space" = "focus mode_toggle";
            "Mod5+Left" = "workspace prev";
            "Mod5+Right" = "workspace next";
            "${mod}+G" = "sticky toggle";
            "${mod}+${alt}+Down" = "move workspace to output down";
            "${mod}+${alt}+Up" = "move workspace to output up";
            "${mod}+${alt}+Left" = "move workspace to output left";
            "${mod}+${alt}+Right" = "move workspace to output right";
            "XF86AudioMute" = "exec amixer set Master toggle";
            "XF86AudioLowerVolume" = "exec amixer set Master 5%-";
            "XF86AudioRaiseVolume" = "exec amixer set Master 5%+";
            "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
            "Print" = "exec flameshot full";
            "${mod}+Shift+S" = "exec flameshot gui";
          };
          assigns = {
            "${ws-code}" = [ { class = "VSCodium"; } ];
            "${ws-fire}" = [
              { class = "firefox"; }
              { class = "firefox-default"; }
            ];
            "${ws-spot}" = [ { class = "spotify"; } ];
            "${ws-pdf}" = [
              { class = "Evince"; }
              { class = "viewnior"; }
            ];
            "${ws-mail}" = [ { class = "thunderbird"; } ];
            "${ws-irc}" = [
              { class = "quassel"; }
              { class = "Signal"; }
            ];
            "${ws-stm}" = [ { class = "Steam"; } ];
            "${ws-gimp}" = [ { class = "Gimp"; } ];
          };
          gaps = {
            top = 48;
            inner = 11;
            outer = 0;
          };
          window.border = 0;
          window.titlebar = false;
          floating.titlebar = false;
          floating.border = 0;
        };
        extraConfig = ''
          for_window [class="thunderbird"] focus
          for_window [class="vscodium"] focus
          for_window [class="firefox"] focus
          for_window [class="viewnior"] focus
          for_window [class="Evince"] focus
          for_window [class="quassel"] focus
          for_window [class="Signal"] focus
          for_window [class="^.*"] border pixel 0
        '';
      };
    };
}
