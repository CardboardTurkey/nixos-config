{ lib, ... }:

{
  imports = 
    [
      ./x11_keyboard.nix
      ./boot_loader.nix
      ./xserver.nix
      ./battery.nix
      ./font.nix
      # ./fprintd.nix # doesn't work nicely :(
      ./pkgs_core.nix
      ./pkgs_aux.nix
      ./users.nix
      ./tailscale.nix
      ./openssh.nix
      ./location.nix
      ./gnupg.nix
      ./network.nix
      ./sound.nix
      ./office_vpn.nix
      ./docker.nix
      ./boot.nix
      ./logind.nix
      ./printing.nix
    ];
  # android mounting
  services.gvfs.enable = true;
}
