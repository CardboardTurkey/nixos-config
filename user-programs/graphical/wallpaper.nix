{ config, lib, pkgs, ... }:

{
  # Needed by gtk?
  programs.dconf.enable = true;
  
  home-manager.users.kiran = { pkgs, lib, ... }: {
    home.activation = {
      wallpaper-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! [ -f "$HOME/.background-image" ] 
        then
          $DRY_RUN_CMD wget $VERBOSE_ARG https://w.wallhaven.cc/full/lm/wallhaven-lmjzjr.jpg -O "$HOME/.background-image"
          $DRY_RUN_CMD feh --bg-fill $HOME/.background-image
          $DRY_RUN_CMD betterlockscreen -u ~/.background-image
        fi
      '';
    };
  };
}