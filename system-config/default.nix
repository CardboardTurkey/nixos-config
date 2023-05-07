{ config, lib, ... }:

{
  imports =
    [
      ./x11_keyboard.nix
      ./boot_loader.nix
      ./battery.nix
      ./font.nix
      # ./fprintd.nix # doesn't work nicely :(
      ./pkgs_core.nix
      ./pkgs_aux.nix
      ./users.nix
      ./tailscale.nix
      ./openssh.nix
      ./location.nix
      ./network.nix
      ./sound.nix
      ./office_vpn.nix
      ./docker.nix
      ./boot.nix
      ./logind.nix
      ./printing.nix
      ./file_manager.nix
      ./fwupd.nix
    ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowed_unfree;
}
