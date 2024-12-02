{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking = {
    hostName = "${config.hostname}"; # Define your hostname.
    networkmanager = {
      enable = true;
      plugins = [
        pkgs.networkmanager-openconnect
        pkgs.networkmanager-openvpn
      ];
      dns = "systemd-resolved";
    };
  };
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  services.resolved.enable = true;
  programs.nm-applet.enable = true;
}
