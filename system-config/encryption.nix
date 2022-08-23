{ config, pkgs, ... }:
let
  grub2themes = builtins.fetchTarball "https://github.com/CardboardTurkey/grub2-themes/archive/master.tar.gz";
in
{

  imports = 
    [
      (import (let inputs = {nixpkgs = pkgs;}; in "${grub2themes}"))
    ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/${config.root}";
      preLVM = true;
      allowDiscards = true;
    };
  };
}
