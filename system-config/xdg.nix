{ pkgs, ... }:
{
  xdg = {
    mime.enable = true;
    icons.enable = true;
    portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
