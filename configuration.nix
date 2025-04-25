{ config, lib, ... }:
{

  imports = [ ./core ];

  nix.extraOptions = "experimental-features = nix-command flakes";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowed_unfree;

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 443;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
