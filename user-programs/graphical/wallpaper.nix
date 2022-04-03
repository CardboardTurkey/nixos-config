{ config, lib, pkgs, ... }:

{
  # Needed by gtk?
  programs.dconf.enable = true;
  
  home-manager.users.kiran = { pkgs, lib, ... }: {
    home.activation = {
      wallpaper-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD [ -f "$HOME/.background-image" ] || \
        wget $VERBOSE_ARG https://w.wallhaven.cc/full/lm/wallhaven-lmjzjr.jpg -O "$HOME/.background-image"
      '';
    };
  };
}