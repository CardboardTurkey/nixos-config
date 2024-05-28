{ config, pkgs, ... }:

{
  # For zsh compeletion (apparently)
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  home-manager.users.kiran = {
    home.shellAliases = {
      "less" = "bat --plain";
      "pj" = "${pkgs.bat-extras.prettybat}/bin/prettybat -l json";
    };
    programs.zsh = {
      shellAliases = { "nix-shell" = "nix-shell --command zsh"; };
      enable = true;
      # dotDir = ".config/zsh";
      autosuggestion.enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historySubstringSearch = {
        enable = true;
        searchUpKey = [ "$terminfo[kcuu1]" ];
        searchDownKey = [ "$terminfo[kcud1]" ];
      };
      autocd = true;
      history = {
        save = 10000000;
        size = 1000000000;
        ignoreAllDups = true;
      };
      dirHashes = {
        aoc = "$HOME/git/cardboardturkey/aoc22";
        bft = "$HOME/git/kiran-rust-course/project";
        dg = "$HOME/git/cardboardturkey/dirtygit";
        flash = "$HOME/git/cardboardturkey/flashcard";
        nix = "$HOME/git/cardboardturkey/nixos-config";
        thing = "$HOME/git/cardboardturkey/thing-of-the-day";
        pdg = "$HOME/git/cardboardturkey/pdgid";
        web = "${config.web_dir}";
        infra = "$HOME/git/smoothbraineduk/infrastructure";
        smooth = "$HOME/git/smoothbraineduk";
        wallop = "$HOME/git/cardboardturkey/wallop";
        hep = "$HOME/github/cardboardturkey/hepmc2";
        ci = "$HOME/git/rust-ci/rust-ci";
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
        # New line without accepting command
        bindkey '^[^M' self-insert-unmeta

        ## Unix time converter
        ut() {
            date -d @"$1"
        }

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

        ## Disable flow control
        [[ $- == *i* ]] && stty -ixon

        source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
      '';
      envExtra = ''
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        export MANROFFOPT="-c" # Needed for bat-manpager integration
        export MANPAGER="sh -c 'col -bx | bat --theme Dracula -l man -p'"
        export BETTER_EXCEPTIONS=1
        export PATH=~/.cargo/bin:$PATH
      '';
    };
  };
}
