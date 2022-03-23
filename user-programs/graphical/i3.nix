{ config, lib, pkgs, ... }:

let

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
  home-manager.users.kiran = { pkgs, ... }: {
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
          "XF86Display"           = "exec autorandr --change";
          "${mod}+L"              = "exec betterlockscreen -l blur";
          "${mod}+period"              = "exec rofi -show emoji -modi emoji";
          "${mod}+Control+Return" = "exec termite";
          "${mod}+Return"         = "workspace 1; exec pgrep termite || termite -e tmuxup";
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
          "${ws-mail}" = [{ class="Thunderbird";}];
          "${ws-img}"  = [{ class="viewnior";}];
          "${ws-irc}"  = [{ class="quassel";}];        
        };
        startup = [
          { command = "nitrogen --restore"; always = true; }
          { command = "polybar-msg cmd quit; polybar the_bar&disown"; always = true; }
        ];
      }; 
      extraConfig = ''
        for_window [class="Mail"] focus
        for_window [class="vscodium"] focus
        for_window [class="firefox"] focus
        for_window [class="viewnior"] focus
        for_window [class="Evince"] focus   

        default_border pixel 0
        default_floating_border pixel 0
      '';
    };
  };
}