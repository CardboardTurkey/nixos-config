{ pkgs, ... }:

{
  hardware.gpgSmartcards.enable = true;
  # services.yubikey-agent.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  services.pcscd.enable = true;
  # home-manager.users.kiran = { pkgs, ... }: {
  #   programs.gpg = {
  #     enable = true;
  #     scdaemonSettings = {
  #       disable-ccid = true;
  #     };
  #   };
  # };
}
