{ config, pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [
  #   eww-wayland
  # ];

  fonts.fonts = with pkgs; [
    material-icons
    linearicons-free
  ];

  home-manager.users.kiran = { pkgs, ... }: {
    programs.eww = {
      # enable = true;
      # package = pkgs.eww-wayland;
      # configDir = ../files/eww;
    };
  };
}
