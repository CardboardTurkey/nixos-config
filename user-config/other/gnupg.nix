{ config, lib, pkgs, ... }:

{
  # Not sure what this is
  hardware.gpgSmartcards.enable = true;
  # services.yubikey-agent.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  home-manager.users.kiran = { pkgs, ... }: {
    programs.gpg = {
      enable = true;
    };
  };
}
