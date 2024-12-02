{ pkgs, ... }:
{
  home.packages = with pkgs; [ fzf ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };
}
