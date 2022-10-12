{ config, ... }:
let
  grubby = (builtins.getFlake "github:CardboardTurkey/grub2-themes/9ef89c2eeb3d07aa703cde54de2de58fa1b98491");
in
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/${config.root}";
      preLVM = true;
      allowDiscards = true;
    };
  };
  # import = [ grubby.outputs.nixosModule ];
  # boot.loader.grub2-theme = {
  #   enable = true;
  #   icon = "white";
  #   theme = "whitesur";
  #   screen = "1080p";
  #   splashImage = ../../backgrounds/grub.jpg;
  #   footer = true;
  # };
}
