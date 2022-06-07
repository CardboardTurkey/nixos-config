{ config, ... }:
{
  networking.hostName = "${config.hostname}"; # Define your hostname.
  networking.networkmanager.enable = true;

}
