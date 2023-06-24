{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    pass
    wl-clipboard
    zip
    unzip
    ripgrep
    pciutils
    usbutils
    htop
    tree
    killall
    ncdu
    # update-nix-fetchgit
  ];
}
