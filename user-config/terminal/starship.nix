{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
