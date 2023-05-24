{ config, lib, pkgs, ... }:

{
  # Not sure what this is
  services.pcscd.enable = true;
  hardware.gpgSmartcards.enable = true;
  # services.yubikey-agent.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };
}
