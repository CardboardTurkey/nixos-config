{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [ tailscale ];
  services.tailscale.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ config.services.tailscale.port ];
    checkReversePath = "loose";
  };
}
