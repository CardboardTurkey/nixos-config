{ config, lib, pkgs, modulesPath, ... }:

{

boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

}
