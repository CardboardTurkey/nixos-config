{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.xclip ];
  home-manager.users.kiran = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ nord-vim vim-nix robotframework-vim ];
      vimAlias = true;
      extraConfig = ''
        colorscheme nord
        set nu rnu

        autocmd FileType markdown setlocal spell
        autocmd FileType gitcommit setlocal spell
        autocmd FileType markdown setlocal complete+=kspell
        autocmd FileType gitcommit setlocal complete+=kspell        

        " Remap the incr/decrement keys
        nnoremap <A-a> <C-a>
        nnoremap <A-x> <C-x>

        " Shift the navigation keys because touch typing
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

        " Make space to leader
        noremap <Space> <Nop>
        map <Space> <Leader>

        " Copy to clipboard
        vnoremap  <leader>y  "+y
        nnoremap  <leader>Y  "+yg_
        nnoremap  <leader>y  "+y

        " Paste from clipboard
        nnoremap <leader>p "+p
        nnoremap <leader>P "+P
        vnoremap <leader>p "+p
        vnoremap <leader>P "+P
      '';
    };
  };
}
