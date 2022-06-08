{ lib, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../system-config
      ../user-config
      ../projects # Comment this out if ssh keys are not setup
    ];

  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

}