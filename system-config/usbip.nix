# Attach the remote usb slot with:
# `sudo usbip attach --remote=REMOTE_IP_ADDRESS -b BUSID`
{ pkgs, ... }:
{
  boot.kernelModules = [
    "vhci_hcd"
  ];
  environment.systemPackages = with pkgs; [
    linuxPackages.usbip
  ];
}
