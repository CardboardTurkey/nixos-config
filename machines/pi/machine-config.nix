{ pkgs, config, ... }:

let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/master.tar.gz";

in {

  imports = [
    (import "${home-manager}/nixos")

    ../../system-config/pkgs_core.nix
    ../../system-config/tailscale.nix
    ../../system-config/users.nix
    ../../system-config/network.nix
    ../../system-config/location.nix
    ../../system-config/openssh.nix
    ../../system-config/docker.nix

    ../../user-config/terminal/git.nix
    ../../user-config/terminal/lsd.nix
    ../../user-config/terminal/starship.nix
    ../../user-config/terminal/zsh.nix
    ../../user-config/terminal/neovim.nix
    ../../user-config/terminal/bat.nix
    ../../user-config/terminal/nix_index.nix
    ../../user-config/terminal/direnv.nix

  ];

  hostname = "wren";

  home-manager.users.kiran = _: {
    home.stateVersion = "22.11";
    # Currently fails to build but hopefully fixed in future - 2023-03-21
    manual.manpages.enable = false;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = false;
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];

  # Preserve space by disabling documentation and enaudo ling
  # automatic garbage collection
  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 10d";
  boot.tmp.cleanOnBoot = true;

  users.users.kiran.openssh.authorizedKeys.keys = [ "${config.pgp_auth_ssh}" ];

  # rpi3 only has 1gb ram so we need a swap file (maybe I should make it bigger )
  swapDevices = [{
    device = "/swapfile";
    size = 2048;
  }];

}
