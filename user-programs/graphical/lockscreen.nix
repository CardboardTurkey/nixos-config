{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    xdg = {
      configFile."betterlockscreenrc".source = ../config/betterlockscreenrc;
    };
    services.betterlockscreen ={
      enable = true;
      arguments = [ "blur" ];
    };
    services.screen-locker = {
      enable = true;
    };
  };
}