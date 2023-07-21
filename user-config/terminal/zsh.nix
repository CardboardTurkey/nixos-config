{ config, ... }:

{
  # For zsh compeletion (apparently)
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  home-manager.users.kiran = {
    programs.zsh = {
      enable = true;
      # dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      historySubstringSearch.enable = true;
      autocd = true;
      history.save = 10000000;
      history.size = 1000000000;
      dirHashes = {
        aoc = "$HOME/gitlab/cardboardturkey/aoc22";
        bft = "$HOME/gitlab/kiran-rust-course/project";
        dg = "$HOME/gitlab/cardboardturkey/dirtygit";
        flash = "$HOME/gitlab/cardboardturkey/flashcard";
        nix = "$HOME/gitlab/cardboardturkey/nixos-config";
        thing = "$HOME/gitlab/cardboardturkey/thing-of-the-day";
        pdg = "$HOME/gitlab/cardboardturkey/pdgid";
        web = "${config.web_dir}";
      };
      completionInit = ''
        zstyle ':completion:*' menu select
        autoload -Uz compinit
        compinit
      '';
      initExtra = ''
        # Keybindings
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
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
        if [[ -f ~/ct-gitlab/codethings/cardboardturkey/notes/notes.md ]]
        then
          (cd ~/ct-gitlab/codethings/cardboardturkey/notes/
          bat notes.md)
        fi
      '';
      envExtra = ''
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        export MANPAGER="sh -c 'col -bx | bat --theme Dracula -l man -p'"
        export BETTER_EXCEPTIONS=1
        export PATH=~/.cargo/bin:$PATH
        ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets)
      '';
      shellAliases = {
        "nix-shell" = "nix-shell --command zsh";
        "less" = "bat --plain";
      };
    };
  };
}
