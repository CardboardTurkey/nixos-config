{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    tailscaleAddress = lib.mkOption {
      default = "100.103.252.84";
      type = with lib.types; uniq str;
      description = "Kestrel address on tailscale";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [ tailscale ];
    services.tailscale.enable = true;
    networking.firewall = {
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
    };
  };
}
