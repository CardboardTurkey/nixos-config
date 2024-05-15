{ config, ... }:
# let
#   grubby = (builtins.getFlake "github.com:CardboardTurkey/grub2-themes").outputs.nixosModule;
# in
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # inherit grubby;
  # boot.loader.grub2-theme = {
  #   enable = true;
  #   icon = "white";
  #   theme = "whitesur";
  #   screen = "1080p";
  #   splashImage = ../../backgrounds/grub.jpg;
  #   footer = true;
  # };
}
