{ pkgs, config, ... }:
{
  networking = {
    hostName = "${config.hostname}"; # Define your hostname.
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openconnect ];
      dns = "systemd-resolved";
    };
  };
  services.resolved.enable = true;
  programs.nm-applet.enable = true;
}
