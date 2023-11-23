{ lib, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../system-config
      ../user-config
    ];

  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

}
