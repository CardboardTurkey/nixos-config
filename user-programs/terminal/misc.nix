{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.keychain = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.bat = {
      enable = true;
      config = { theme = "Nord"; };
    };
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ nord-nvim ];
      vimAlias = true;
    };
  };
}