{ pkgs, config, ... }:
{
  networking = {
    hostName = "${config.hostname}"; # Define your hostname.
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openconnect ];
    };
  };
  programs.nm-applet.enable = true;
}
