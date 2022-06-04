{ pkgs, config, ... }:

{
  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  networking.firewall.checkReversePath = "loose";
  environment.systemPackages = with pkgs; [ tailscale ];
}
