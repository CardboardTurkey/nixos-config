# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134

{ config, pkgs, ... }:

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
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./ThinkPadT14.nix
      (import "${home-manager}/nixos")
    ];

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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
        "ls" = "ls --color=auto";
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
      plugins = with pkgs.vimPlugins; [ nord-vim ];
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
    ripgrep
    zip
    unzip
  ];

  # For zsh completion
  environment.pathsToLink = [ "/share/zsh" ];

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

