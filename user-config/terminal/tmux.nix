{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [ nord ];
      prefix = "C-a";
      terminal = "alacritty";
      historyLimit = 500000;
      extraConfig = ''
        # split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %
      '';
    };
  };
}