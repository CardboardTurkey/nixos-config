{ config, lib, pkgs, ... }:
{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi.override { 
        plugins = [ pkgs.rofi-emoji ]; 
      };
    };
  };
}