{ pkgs, ... }:
{
  home.sessionVariables.EDITOR = "vim";
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      robotframework-vim
    ];
    vimAlias = true;

    extraConfig = ''
      " Dont colour the background
      hi Normal ctermbg=NONE guibg=NONE

      " Line numbering
      set nu rnu

      autocmd FileType markdown setlocal spell spelllang=en_gb
      autocmd FileType gitcommit setlocal spell spelllang=en_gb
      autocmd FileType markdown setlocal complete+=kspell
      autocmd FileType gitcommit setlocal complete+=kspell        
      autocmd FileType gitcommit call Commit()

      function Commit()
        set spellcapcheck= " Ideally this would only apply to first line

        inoreabbrev <buffer> BB BREAKING CHANGE:
        nnoremap    <buffer> i  i<C-r>=<sid>commit_type()<CR>

        fun! s:commit_type()
          call complete(1, ['build: ', 'chore: ', 'ci: ', 'docs: ', 'feat: ', 'fix: ', 'perf: ', 'refactor: ', 'revert: ', 'style: ', 'test: '])
          nunmap <buffer> i
          return '''
        endfun
      endfunction

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
}
