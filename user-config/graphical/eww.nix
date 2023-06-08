{ config, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    material-icons
  ];
  environment.systemPackages = with pkgs; [
    eww-wayland
  ];
  home-manager.users.kiran = { pkgs, ... }: {
    programs.eww = {
      # enable = true;
      # package = pkgs.eww-wayland;
      # configDir = ../files/eww;
    };
  };
}
