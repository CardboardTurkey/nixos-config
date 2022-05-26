{ config, pkgs, ... }:

let

  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

in

{
  nixpkgs.overlays = [ (self: super: { local = import ./my-pkgs { pkgs = super; }; }) ];

  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./hardware-extra.nix
      ./core
      ./system-config
      (import "${home-manager}/nixos")
      ./user-config
    ];

  nix.extraOptions = "experimental-features = nix-command flakes";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

