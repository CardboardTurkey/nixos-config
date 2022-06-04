{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in

{

  imports =
    [ 
      (import "${home-manager}/nixos")

      ../../system-config/boring_stuff.nix
      ../../system-config/pkgs_core.nix
      ../../system-config/tailscale.nix
      ../../system-config/users.nix

      ../../user-config/terminal/git.nix
      ../../user-config/terminal/starship.nix
      ../../user-config/terminal/zsh.nix
      ../../user-config/terminal/neovim.nix
    ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  boot.loader.raspberryPi = {
    enable = true;
    uboot.enable = true;
    version = 3;
  };
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    networkmanager = {
      enable = true;
    };
  };

  # rpi3 only has 1gb ram so we need a swap file (maybe I should make it bigger )
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];

}
