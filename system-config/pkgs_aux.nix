{ pkgs, pkgs-unstable, ... }:

{
  imports = [ ./pkgs_mine/dirtygit/module.nix ];
  nixpkgs.overlays =
    [ (self: super: { local = import ./pkgs_mine { pkgs = super; }; }) ];

  environment.systemPackages = with pkgs; [
    firefox
    wdisplays
    thunderbird
    quasselClient
    local.scripts
    local.logiops
    local.dirtygit
    feh
    arandr
    brightnessctl
    flameshot
    pkgs-unstable.signal-desktop
    xorg.xev
    pavucontrol
    python3
    gimp
    ffmpeg
    local.newrust
    local.pyup
    # local.cargo-aoc
    kooha
    rust-script
    dasel
    sound-juicer
    gitui
    nixfmt-classic
    gcolor3
    borgbackup
  ];
}
