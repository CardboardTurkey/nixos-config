{ pkgs, ... }: {
  home.packages = with pkgs; [ material-icons linearicons-free ];
  fonts.fontconfig.enable = true;
  programs.eww = {
    enable = true;
    configDir = ../files/eww;
  };
}
