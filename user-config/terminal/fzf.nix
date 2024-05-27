{ config, pkgs, ... }:
let
  fzf-tab-source = pkgs.fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "fzf-tab-source";
    rev = "0cae36455483455a9a7b8a918962c60b16d0d353";
    hash = "sha256-J+CxlfJXsdFvNZIR2Y0kHhoonE2tC0IXpVnsGBCPyB8=";
  };
in
{
  environment.systemPackages = with pkgs; [
    mdcat
    pandoc
    grc
  ];
  home-manager.users.kiran = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      colors = {
        fg = "#${config.nord5}";
        bg = "-1";
        hl = "#${config.nord9}";
        # fg+ doesnt seem to work for fzf-tab
        "fg+" = "#${config.nord5}";
        "bg+" = "#${config.nord0}";
        "hl+" = "#${config.nord9}";
        info = "#${config.nord13}";
        prompt = "#${config.nord11}";
        pointer = "#${config.nord15}";
        marker = "#${config.nord14}";
        spinner = "#${config.nord15}";
        header = "#${config.nord14}";
        gutter = "-1";
        border = "#${config.nord3}";
      };
      defaultOptions = [
        "--border rounded"
        "--preview-window border-rounded"
      ];
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
