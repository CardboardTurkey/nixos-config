{ pkgs, ... }:

{

  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
      ../../system-config
      ../../user-config
    ];

  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

  # For touch-to-click
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  environment.systemPackages = with pkgs; [
    gimp
  ];
}
