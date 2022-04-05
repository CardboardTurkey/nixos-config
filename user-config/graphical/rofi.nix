{ config, lib, pkgs, ... }:
{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi.override { 
        plugins = [ pkgs.rofi-emoji ]; 
      };
      extraConfig = {
        modi = "drun,run,window,ssh,combi";
        terminal = "alacritty";
        icon-theme = "Zafiro-icons";
      };
    };
    xdg = {
      configFile."rofi/clean.rasi".source = ../files/rofi/clean.rasi;
      configFile."rofi/colors.rasi".source = ../files/rofi/colors.rasi;
      configFile."rofi/powermenu.rasi".source = ../files/rofi/powermenu.rasi;
    };
  };
}
