{ pkgs, ... }:
let
  fzf-tab-source = pkgs.fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "fzf-tab-source";
    rev = "0cae36455483455a9a7b8a918962c60b16d0d353";
    hash = "sha256-J+CxlfJXsdFvNZIR2Y0kHhoonE2tC0IXpVnsGBCPyB8=";
  };
in {
  home = {
    packages = with pkgs; [ mdcat pandoc grc ];
    file.".lessfilter" = {
      executable = true;
      # Note the TF and torch shit won't work without python deps
      text = ''
        #! /usr/bin/env bash
        has_cmd() {
          for opt in "$@"; do
            if command -v "$opt" >/dev/null; then
              continue
            else
              return $?
            fi
          done
        }

        mime=$(${pkgs.file}/bin/file -Lbs --mime-type "$1")
        category=''${mime%%/*}
        kind=''${mime##*/}
        ext=''${1##*.}
        if [ "$kind" = octet-stream ]; then
          if [[ $1 == *events.out.tfevents.* ]]; then
            python <<EOF
        from contextlib import suppress
        import sys
        from time import gmtime, strftime

        import pandas as pd
        import plotext as plt
        from tensorboard.backend.event_processing.event_file_loader import (
            EventFileLoader,
        )

        file = "$1"
        df = pd.DataFrame(columns=["Step", "Value"])
        df.index.name = "YYYY-mm-dd HH:MM:SS"

        for event in EventFileLoader(file).Load():
            with suppress(IndexError):
                df.loc[strftime("%F %H:%M:%S", gmtime(event.wall_time))] = [  # type: ignore
                    event.step,  # type: ignore
                    event.summary.value[0].tensor.float_val[0],  # type: ignore
                ]
        df.index = pd.to_datetime(df.index)  # type: ignore
        df.Step = df.Step.astype(int)
        plt.plot(df.Step, df.Value, marker="braille")
        plt.title(event.summary.value[0].metadata.display_name)  # type: ignore
        plt.clc()
        plt.show()
        df.to_csv(sys.stdout, "\t")
        EOF
          elif [[ $(basename "$1") == data.mdb ]]; then
            python <<EOF
        from os.path import dirname as dirn
        import lmdb

        with lmdb.open(dirn("$1")) as env, env.begin() as txn:
            for key, val in txn.cursor():
                print(key.decode())
        EOF
          fi
        elif [ "$kind" = zip ] && [ "$ext" = pth ]; then
          python <<EOF
        import torch

        data = torch.load("$1")
        if isinstance(data, torch.Tensor):
            print(data.shape)
        print(data)
        EOF
        elif [ "$kind" = json ]; then
          if [ "$ext" = ipynb ]; then
            ${pkgs.jupyter}/bin/jupyter nbconvert --to python --stdout "$1" | ${pkgs.bat}/bin/bat --color=always -plpython
          else
            ${pkgs.jq}/bin/jq -Cr . "$1"
          fi
        elif [ "$kind" = vnd.sqlite3 ]; then
          yes .q | ${pkgs.sqlite}/bin/sqlite3 "$1" | ${pkgs.bat}/bin/bat --color=always -plsql
        # https://github.com/wofr06/lesspipe/pull/107
        elif [ -d "$1" ]; then
          ${pkgs.eza}/bin/eza -hl --git --color=always --icons "$1"
        # https://github.com/wofr06/lesspipe/pull/110
        elif [ "$kind" = pdf ]; then
          ${pkgs.poppler_utils}/bin/pdftotext -q "$1" - | sed "s/\f/$(hr ─)\n/g"
        # https://github.com/wofr06/lesspipe/pull/115
        elif [ "$kind" = rfc822 ]; then
          ${pkgs.bat}/bin/bat --color=always -lEmail "$1"
        elif [ "$kind" = javascript ]; then
          ${pkgs.bat}/bin/bat --color=always -ljs "$1"
        # https://github.com/wofr06/lesspipe/pull/106
        elif [ "$category" = image ]; then
          ${pkgs.chafa}/bin/chafa "$1"
        # https://github.com/wofr06/lesspipe/pull/117
        elif [ "$category" = text ]; then
          ${pkgs.bat}/bin/bat --color=always --style plain "$1"
        else
          exit 1
        fi
      '';
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--border rounded" "--preview-window border-rounded" ];
  };
  programs.zsh = {
    initExtra = ''
      export FAST_WORK_DIR=XDG
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # disable sort when completing `git`
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:git-commit:*' sort false
      zstyle ':completion:*:git-rebase:*' sort false

      # set descriptions format to enable group support
      # NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'

      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no

      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.eza}/bin/eza -1 --color=always --icons=always $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview '${pkgs.eza}/bin/eza -1 --color=always --icons=always $realpath'

      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # Because of the border
      zstyle ':fzf-tab:*' fzf-pad 4

      source ${fzf-tab-source}/*.plugin.zsh
    '';
  };
}
