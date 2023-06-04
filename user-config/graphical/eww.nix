{ config, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.eww = {
      # enable = true;
      # package = pkgs.eww-wayland;
      # configDir = ../files/eww;
    };
  };
}
