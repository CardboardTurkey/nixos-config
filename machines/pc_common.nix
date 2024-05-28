{
  imports = [ ../system-config ../user-config ];

  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

}
