{ config, lib, pkgs, modulesPath, ... }:

{

  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

  services.xserver.displayManager.autoLogin = { 
    enable = true; 
    user = "kiran"; 
  };

}
