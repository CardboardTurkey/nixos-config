{
  home-manager.users.kiran = { pkgs, osConfig, ... }:
    let
      fzf-tab-source = pkgs.fetchFromGitHub {
        owner = "Freed-Wu";
        repo = "fzf-tab-source";
        rev = "0cae36455483455a9a7b8a918962c60b16d0d353";
        hash = "sha256-J+CxlfJXsdFvNZIR2Y0kHhoonE2tC0IXpVnsGBCPyB8=";
      };
    in {
      home.packages = with pkgs; [ mdcat pandoc grc ];
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        colors = {
          fg = "#${osConfig.nord5}";
          bg = "-1";
          hl = "#${osConfig.nord9}";
          # fg+ doesnt seem to work for fzf-tab
          "fg+" = "#${osConfig.nord5}";
          "bg+" = "#${osConfig.nord0}";
          "hl+" = "#${osConfig.nord9}";
          info = "#${osConfig.nord13}";
          prompt = "#${osConfig.nord11}";
          pointer = "#${osConfig.nord15}";
          marker = "#${osConfig.nord14}";
          spinner = "#${osConfig.nord15}";
          header = "#${osConfig.nord14}";
          gutter = "-1";
          border = "#${osConfig.nord3}";
        };
        defaultOptions =
          [ "--border rounded" "--preview-window border-rounded" ];
      };
      programs.zsh = {
        initExtra = ''
          export FAST_WORK_DIR=XDG
          source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

          # disable sort when completing `git`
          zstyle ':completion:*:git:*' sort false

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
    };
}
