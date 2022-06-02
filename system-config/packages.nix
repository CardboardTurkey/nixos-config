{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    firefox
    thunderbird
    pass
    wl-clipboard
    quasselClient
    ripgrep
    zip
    unzip
    rustup
    gcc
    local.scripts
    local.logiops
    htop
    feh
    arandr
    brightnessctl
    flameshot
    pciutils
    usbutils
    signal-desktop
    xorg.xev
    pavucontrol
  ];
}
