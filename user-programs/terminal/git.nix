{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {   
    programs.git = {
      enable = true;
      userName  = "Kiran Ostrolenk";
      userEmail = "kiran.ostrolenk@codethink.co.uk";
      extraConfig =  { 
        core = { editor = "vim"; } ; 
        pull = { rebase = "true"; } ; 
        alias = {
          co = "checkout";
          ci = "commit";
          st = "status";
          br = "branch";
          hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
          type = "cat-file -t";
          dump = "cat-file -p";
        };
      };
      delta = {
        enable = true;
        options = {
          features = "side-by-side line-numbers decorations"; 
          whitespace-error-style = "22 reverse";
          syntax-theme = "Nord";
          plus-style = "syntax '#165f1a'";
          plus-emph-style = "syntax '#028105'";
          minus-style = "syntax '#380101'";
          decorations = { 
            commit-decoration-style = "bold yellow box ul"; 
            file-decoration-style = "none"; 
            file-style = "bold yellow ul"; 
            hunk-header-decoration-style = "cyan box ul";
          }; 
          line-numbers = {
            line-numbers-left-style = "cyan";
            line-numbers-right-style = "cyan";
            line-numbers-minus-style = "124";
            line-numbers-plus-style = "28";
          };
        };
      };
    };
  };
}