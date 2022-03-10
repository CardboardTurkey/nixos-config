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
          "${mod}+$alt+Down"      = "move workspace to output down";
          "${mod}+$alt+Up"        = "move workspace to output up";
          "${mod}+$alt+Left"      = "move workspace to output left";
          "${mod}+$alt+Right"     = "move workspace to output right";
        };
        assigns = {
          "${ws-code}" = [{ class="VSCodium";}];
          "${ws-fire}" = [{ class="Firefox";}];
          "${ws-chrm}" = [{ class="Google-chrome";}];
          "${ws-spot}" = [{ class="spotify";}];
          "${ws-pdf}"  = [{ class="Evince";}];
          "${ws-mail}" = [{ class="Mail";}];
          "${ws-img}"  = [{ class="viewnior";}];
          "${ws-irc}"  = [{ title="quassel";}];        
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
  };

}