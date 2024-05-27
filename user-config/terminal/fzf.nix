{ config, pkgs, ... }:
{
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
  };
}
