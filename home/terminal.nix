{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
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
        if [[ -f ~/gitlab.codethink/codethings/kiranostrolenk/notes/notes.md ]]
        then
          (cd ~/gitlab.codethink/codethings/kiranostrolenk/notes/
          bat notes.md)
        fi
      '';
      envExtra = ''
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        export MANPAGER="sh -c 'col -bx | bat --theme Dracula -l man -p'"
        export BETTER_EXCEPTIONS=1
      '';
      shellAliases = {
        "nix-zshell" = "nix-shell --command zsh";
        "ls" = "ls --color=auto";
	"less" = "bat --plain";
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
      backgroundColor = "${config.nord0}";
      colorsExtra = ''
        color0  = ${config.nord1}
        color1  = ${config.nord11}
        color2  = ${config.nord14}
        color3  = ${config.nord13}
        color4  = ${config.nord9}
        color5  = ${config.nord15}
        color6  = ${config.nord8}
        color7  = ${config.nord5}
        color8  = ${config.nord3}
        color9  = ${config.nord11}
        color10 = ${config.nord14}
        color11 = ${config.nord13}
        color12 = ${config.nord9}
        color13 = ${config.nord15}
        color14 = ${config.nord7}
        color15 = ${config.nord6}
      '';
      cursorColor = "${config.nord4}";
      cursorForegroundColor = "${config.nord0}";
      foregroundColor = "${config.nord4}";
      foregroundBoldColor = "${config.nord4}";
      font = "DejaVuSansMono Nerd Font Mono 20";
    };
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ nord-vim ];
      vimAlias = true;
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
  };
}