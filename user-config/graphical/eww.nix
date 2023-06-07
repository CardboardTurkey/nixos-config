{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    material-icons
  ];
  home-manager.users.kiran = { pkgs, ... }: {
    programs.eww = {
      # enable = true;
      # package = pkgs.eww-wayland;
      # configDir = ../files/eww;
    };
  };
}
