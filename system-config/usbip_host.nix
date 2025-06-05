{ pkgs, ... }:
{
  boot.kernelModules = [
    "usbip_host"
    "vhci_hcd"
  ];
  networking.firewall.allowedTCPPorts = [ 3240 ];
  systemd.services = {
    usbipd = {
      enable = true;
      description = "USB-IP Daemon";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.linuxPackages.usbip}/bin/usbipd";
      };
      wantedBy = [ "multi-user.target" ];
    };
    # Determine the busid of the slot you want to expose with `usbip list -l`.
    # Use the busid in the service name, in my case it's 1-1.
    "usbip-bind@1-1" = {
      enable = true;
      description = "USB-IP Binding on bus id %I";
      after = [
        "network-online.target"
        "usbipd.service"
      ];
      wants = [ "network-online.target" ];
      requires = [ "usbipd.service" ];
      serviceConfig = {
        Type = "exec";
        RestartSec = 5;
        ExecStart = "${pkgs.linuxPackages.usbip}/bin/usbip bind -b %i";
        RemainAfterExit = "yes";
        ExecStop = "${pkgs.linuxPackages.usbip}/bin/usbip unbind -b %i";
        Restart = "on-failure";
      };
    };
  };
}
