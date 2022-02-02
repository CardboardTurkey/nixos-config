# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  codium-extensions = (with pkgs.vscode-extensions; [
        # bbenoist.Nix
        jnoortheen.nix-ide
        arcticicestudio.nord-visual-studio-code
        ms-python.python
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
  ws-term = "0";
  ws-code = "1";
  ws-fire = "2";
  ws-spot = "3";
  ws-pdf = "4";
  ws-mail = "5";
  ws-img = "6";
  ws-irc = "7";
  ws-chrm = "8";

  # lock_screen = pkgs.writeScriptBin "lock_screen" ''
  #   for i in $(${pkgs.lxc}/bin/lxc list -c 4 --format json | ${pkgs.jq}/bin/jq --raw-output 'map(select(.state.network.eth0.addresses[0].address != null)) | .[] | .state.network.eth0.addresses[0].address'); do echo -n "$i,"; done
  # '';

in

{
  imports =
    [ # Include the results of the hardware scan.
      ./ThinkPadT14.nix
      (import "${home-manager}/nixos")
    ];

  nixpkgs.overlays = [ (import ./overlays) ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/d0ad36ad-4630-4764-ae08-a8c3e788d521";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking.hostName = "finch"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.enp0s20f0u2u1.useDHCP = true;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    noto-fonts-emoji
    font-awesome
  ];

  # libexec for i3 and latter for zsh completion
  environment.pathsToLink = [ "/libexec" "/share/zsh" ]; # links /libexec from derivations to /run/current-system/sw 

  # i3
  
  # services.dbus.packages = with pkgs; [ gnome3.dconf ];
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    # displayManager = {
    #   # defaultSession = "none+i3";
    #   # startx.enable = true;
    # };

    windowManager.i3 = {
      enable = true;
    #   extraPackages = with pkgs; [
    #     dmenu #application launcher most people use
    #     i3status # gives you the default i3 status bar
    #     i3lock #default i3 screen locker
    #     i3blocks #if you are planning on using i3blocks over i3status
    #  ];
    };
  };
    
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiran = {
    isNormalUser = true;
    home = "/home/kiran";
    description = "Kiran Ostrolenk";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  
  home-manager.users.kiran = { pkgs, ... }: {
    # home.packages = [ pkgs.atool pkgs.httpie ];

    # Rofi stuff
    home = {
      file."powermenu" = {
        executable = true;
        text = ''
          if [ -z "$@" ]; then
              echo -en "Shutdown\0icon\x1fxfsm-shutdown\n"
              echo -en "Logout\0icon\x1fxfsm-logout\n"
              echo -en "Suspend\0icon\x1fhibernate\n"
              echo -en "Reboot\0icon\x1fxfsm-reboot\n"
          else
              if [ "$1" = "Shutdown" ]; then
                  poweroff
              elif [ "$1" = "Logout" ]; then
                  i3-msg exit
              elif [ "$1" = "Reboot" ]; then
                  reboot
              elif [ "$1" = "Hibernate" ]; then
                  systemctl hibernate
              fi
          fi
        '';
        target = ".local/bin/powermenu";
      };
    };
    xdg = {
      configFile."rofi".source = ./.config/rofi;
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
          "${mod}+Return"           = "workspace 1; exec pgrep termite || termite";
          "${mod}+Control+space"  = "focus mode_toggle";
          "${mod}+Control+Left"   = "workspace prev";
          "${mod}+Control+Right"  = "workspace next";
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
    services.betterlockscreen = {
      enable = true;
      arguments = [ "dimblur" "-t" "'The way is shut'" ];
    };
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [ nord ];
      prefix = "C-a";
      terminal = "xterm-termite";
      historyLimit = 500000;
      extraConfig = ''
        # split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %
      '';
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      autocd = true;
      history.save = 10000000;
      history.size = 1000000000;
      # completionInit = "zstyle ':completion:*' menu select\nautoload -Uz compinit\ncompinit";
      completionInit = ''
        zstyle ':completion:*' menu select
        autoload -Uz compinit
        compinit
      '';
      initExtra = ''
        # Keybindings
        bindkey "^[[1~" beginning-of-line
        bindkey "^[[4~" end-of-line
        bindkey "''${terminfo[kdch1]}" delete-char
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        my-backward-delete-word() {
          local WORDCHARS=''${WORDCHARS/\//}
          zle backward-delete-word
        }
        zle -N my-backward-delete-word
        bindkey '^H' my-backward-delete-word
        bindkey '^[[3;5~' kill-word

        ## COMPRESSION FUNCTION ##
        compress() {
            FILE=$1
            shift
            case $FILE in
                *.tar.bz2) tar cjf $FILE $*  ;;
                *.tar.gz)  tar czf $FILE $*  ;;
                *.tgz)     tar czf $FILE $*  ;;
                *.zip)     zip $FILE $*      ;;
                *.rar)     rar $FILE $*      ;;
                *)         echo "Filetype not recognized" ;;
          esac
        }

        ## EXTRACT FUNCTION ##
        extract () {
            if [ -f $1 ] ; then
                case $1 in
                    *.tar.bz2)   tar xjf $1     ;;
                    *.tar.gz)    tar xzf $1     ;;
                    *.bz2)       bunzip2 $1     ;;
                    *.rar)       unrar e $1     ;;
                    *.gz)        gunzip $1      ;;
                    *.tar)       tar xf $1      ;;
                    *.tbz2)      tar xjf $1     ;;
                    *.tgz)       tar xzf $1     ;;
                    *.zip)       unzip $1       ;;
                    *.Z)         uncompress $1  ;;
                    *.7z)        7z x $1        ;;
                    *)     echo "'$1' cannot be extracted via extract()" ;;
                esac
            else
                echo "'$1' is not a valid file"
            fi
        }

      '';
      envExtra = ''
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        export MANPAGER="sh -c 'col -bx | bat --theme Dracula -l man -p'"
        export BETTER_EXCEPTIONS=1
      '';
      shellAliases = {
        "nix-zshell" = "nix-shell --command zsh";
      };
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
        };
      };
    };
    programs.keychain = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.bat = {
      enable = true;
      config = { theme = "Nord"; };
    };
    programs.termite = {
      enable = true;
      enableVteIntegration = true;
      allowBold = true;
      backgroundColor = "#2e3440";
      colorsExtra = ''
        color0  = #3b4252
        color1  = #bf616a
        color2  = #a3be8c
        color3  = #ebcb8b
        color4  = #81a1c1
        color5  = #b48ead
        color6  = #88c0d0
        color7  = #e5e9f0
        color8  = #4c566a
        color9  = #bf616a
        color10 = #a3be8c
        color11 = #ebcb8b
        color12 = #81a1c1
        color13 = #b48ead
        color14 = #8fbcbb
        color15 = #eceff4
      '';
      cursorColor = "#d8dee9";
      cursorForegroundColor = "#2e3440";
      foregroundColor = "#d8dee9";
      foregroundBoldColor = "#d8dee9";
      font = "DejaVuSansMono Nerd Font Mono 20";
    };
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ nord-vim i3config-vim ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse-=a
      '';
    };
    programs.git = {
      enable = true;
      userName  = "Kiran Ostrolenk";
      userEmail = "kiran.ostrolenk@codethink.co.uk";
      extraConfig =  { 
        core = { editor = "vim"; } ; 
        pull = { rebase = "true"; } ; 
        alias = {
          co = "checkout";
          ci = "commit";
          st = "status";
          br = "branch";
          hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
          type = "cat-file -t";
          dump = "cat-file -p";
        };
      };
      delta = {
        enable = true;
        options = {
          features = "side-by-side line-numbers decorations"; 
          whitespace-error-style = "22 reverse";
          syntax-theme = "Nord";
          plus-style = "syntax '#165f1a'";
          plus-emph-style = "syntax '#028105'";
          minus-style = "syntax '#380101'";
          decorations = { 
            commit-decoration-style = "bold yellow box ul"; 
            file-decoration-style = "none"; 
            file-style = "bold yellow ul"; 
            hunk-header-decoration-style = "cyan box ul";
          }; 
          line-numbers = {
            line-numbers-left-style = "cyan";
            line-numbers-right-style = "cyan";
            line-numbers-minus-style = "124";
            line-numbers-plus-style = "28";
          };
        };
      };
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
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    firefox
    thunderbird
    pass
    quasselClient
    lxappearance
    brightnessctl
    my-script
    rofi
    ripgrep
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

