{ config, lib, pkgs, ... }:

{
  # Not sure what this is
  services.pcscd.enable = true;
  hardware.gpgSmartcards.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
