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
        set nu rnu
        autocmd FileType markdown setlocal spell
        autocmd FileType gitcommit setlocal spell
        autocmd FileType markdown setlocal complete+=kspell
        autocmd FileType gitcommit setlocal complete+=kspell        

	nnoremap j h
	nnoremap k j
	nnoremap l k
	nnoremap ; l
	nnoremap h ;

	vnoremap j h
	vnoremap k j
	vnoremap l k
	vnoremap ; l
	vnoremap h ;
      '';
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };
}
