{ config, lib, ... }:

{
  imports =
    [
      ./boot_loader.nix
      ./greetd.nix
      ./battery.nix
      ./font.nix
      ./pam.nix
      ./pkgs_core.nix
      ./pkgs_aux.nix
      ./users.nix
      ./tailscale.nix
      ./openssh.nix
      ./location.nix
      # ./podman.nix
      ./network.nix
      ./sound.nix
      ./office_vpn.nix
      ./docker.nix
      ./boot.nix
      ./logind.nix
      ./printing.nix
      ./file_manager.nix
      ./fwupd.nix
      ./thefuck.nix
      ./yubikey.nix
      ./qmk.nix
      ./flatpack.nix
      ./upower.nix
      # ./hedgedoc.nix
    ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowed_unfree;
}
