{ config, lib, pkgs, ... }:

{
  # Needed by gtk?
  programs.dconf.enable = true;
  
  home-manager.users.kiran = { pkgs, ... }: {
    # home.packages = [ pkgs.atool pkgs.httpie ];
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.zafiro-icons;
        name = "Zafiro-icons";
      };
      font = {
        name = "DejaVu Sans 12";
      };
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
    };
  };
}