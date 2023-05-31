{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  T14_ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMR2vu2GJG43rrS6wRD4sx6IYZ7CGaKi/5Dx1VmTU4Sv finch-20-06-2022";
  XPS_ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1t57Tm6KqoGTn7GnrMC9g+5EcmSIX6zLDYdRfXHOl9 kestrel-13-07-2022";
in

{

  imports =
    [
      (import "${home-manager}/nixos")

      ../../system-config/pkgs_core.nix
      ../../system-config/tailscale.nix
      ../../system-config/users.nix
      ../../system-config/network.nix
      ../../system-config/location.nix
      ../../system-config/openssh.nix
      ../../system-config/docker.nix
      ../../system-config/gnupg.nix

      ../../user-config/terminal/git.nix
      ../../user-config/terminal/lsd.nix
      ../../user-config/terminal/starship.nix
      ../../user-config/terminal/zsh.nix
      ../../user-config/terminal/neovim.nix
      ../../user-config/terminal/bat.nix
      ../../user-config/terminal/keychain.nix
      ../../user-config/terminal/nix_index.nix
      ../../user-config/terminal/direnv.nix
      ../../user-config/other/webserver.nix
    ];

  environment.systemPackages = with pkgs; [
    gnupg
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

  boot.loader.raspberryPi = {
    enable = true;
    uboot.enable = true;
    version = 3;
  };
  boot.loader.grub.enable = false;

  hardware.enableRedistributableFirmware = false;
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];

  # Preserve space by disabling documentation and enaudo ling
  # automatic garbage collection
  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 10d";
  boot.cleanTmpDir = true;

  users.users.kiran.openssh.authorizedKeys.keys = [ "${T14_ssh_key}" "${XPS_ssh_key}" ];

  # rpi3 only has 1gb ram so we need a swap file (maybe I should make it bigger )
  swapDevices = [{ device = "/swapfile"; size = 2048; }];

}
