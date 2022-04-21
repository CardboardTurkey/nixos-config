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
      plugins = with pkgs.vimPlugins; [ nord-vim ];
      vimAlias = true;
      extraConfig = ''
        colorscheme nord
        set rnu
        autocmd FileType markdown setlocal spell
        autocmd FileType gitcommit setlocal spell
        autocmd FileType markdown setlocal complete+=kspell
        autocmd FileType gitcommit setlocal complete+=kspell        
      '';
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };
}