{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  T14_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmxAEbpaxSCoahAH0cCV+tuENZ8iJY7U+NETdHFvwmqYHGQ7aMuucy0CB8qdNTmbLfCwFoOhFMilmEru31CHaHVbJFg4+LECZC6cOOI7Wuu2PbNlVydrwErpszSVlvxyuN63ucjYVCjV0k6n5geZ59ZeTDI4KDzFNwBRnV0LRKHUVdC/TjTnPBOGl+VObyv6/WEqLP4uZEmfH4pAao7LQO8C04eknKDCOTYGDJ+6E5KScrn/9G8zIFAr1OVBjlD3y/zVZFIalfn4VkpdxV4KsW1wHXlVfMz6YioYCC0PBxtSZP0vswFrF28vxRpHPZwLnb1OLk/isx0sMmF+3cEIyE2UwsaIJaJ60hGc34EZBtitkonD1uvP/28UlKCMKV3i4iXiKIpjDFRKvH72arteIOGKBQ8JTHmgrzmsZgcolD8vieXZ+3WKax3kBVbnwK6estmrAbdQ3726bfHZOgQGmlT7sA9MV+Cqie1HG8a/49bLnE5NmS9sdZhbDloAs/UfU= kiran@finch";
  XPS_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPma1gqc/1JDbbF1svqgR2qqkmhS90LHSY4JpVZ8/M0S8x6ZvfizR9OoMGz9bdk4NT5YCLC0qaGV3f8K1RBfHCSRH2qdlNNPKEiq92lvxkuO8A2BqtpZhNUJAAP4Mc1NJYgXpDBqZRA1W15Uz0YOZjLZlpwtv+jaWyqsu7WboAZz+8BRK9QNGmWu5mDVpatS/iqJouzIrpx538RSxxrpmSza3iYv7zmSwjxAqIs45RZlcEmup8l0FR+dz/HCnPevMIxtXiJfgljWDPTV/G2B//XJgx67oY6dL5UXu4MNr7g5TbcW3yiFMT6OrNpfEodq+rgSmRVQHjXyurRjJWCOaAb88GiSMfIhJB9DVW4OTvjvbdPYlk5tSKAOIkjonhUo+/ylaGMvffYPAcT3lTnYeDidbunEsxkqo7KcJiK65JM4O3B+sChAqsIQDE4ZXGc14XHYxfHTdEVjR+IxL6PzOv3wmjQEE4fyCARE7yD92pTl385E6TM1ngupf6eKYENgM= kiran@kestrel";
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

      ../../user-config/terminal/git.nix
      ../../user-config/terminal/starship.nix
      ../../user-config/terminal/zsh.nix
      ../../user-config/terminal/neovim.nix
      ../../user-config/terminal/bat.nix
      ../../user-config/terminal/keychain.nix
      ../../user-config/terminal/nix_index.nix
      ../../user-config/terminal/direnv.nix
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

  users.users.kiran.openssh.authorizedKeys.keys = [ "${T14_ssh_key}" "${XPS_ssh_key}" ];

  # rpi3 only has 1gb ram so we need a swap file (maybe I should make it bigger )
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];

}
