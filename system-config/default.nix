{ config, lib, ... }:

{
  imports = [
    ./at.nix
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
    ./printing.nix
    ./file_manager.nix
    ./fwupd.nix
    ./yubikey.nix
    ./qmk.nix
    ./flatpak.nix
    ./upower.nix
    ./jellyfin.nix
    # ./hedgedoc.nix
    ./nix-index-database.nix
    ./sops.nix
    ./hyprland.nix
    ./bluetooth.nix
    ./gnupg.nix
    ./devenv.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) config.allowed_unfree;
}
