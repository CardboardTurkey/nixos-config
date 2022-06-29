{ lib, ... }:

{
  imports = 
    [
      ./x11_keyboard.nix
      ./encryption.nix
      ./xserver.nix
      ./battery.nix
      ./font.nix
      ./fprintd.nix
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
    ];
}
