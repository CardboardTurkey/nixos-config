{ pkgs, ... }:

{
  imports = [ ./pkgs_mine/dirtygit/module.nix ];
  nixpkgs.overlays = [ (self: super: { local = import ./pkgs_mine { pkgs = super; }; }) ];

  environment.systemPackages = with pkgs; [
    wdisplays
    thunderbird
    quasselClient
    local.scripts
    # local.dirtygit
    local.spinner
    feh
    arandr
    flameshot
    signal-desktop
    xorg.xev
    pavucontrol
    pwvucontrol
    gimp
    ffmpeg
    local.newrust
    local.pyup
    # local.cargo-aoc
    kooha
    rust-script
    dasel
    # sound-juicer
    nixfmt-rfc-style
    gcolor3
    borgbackup
    nautilus
    evince # for nautilus pdf preview
    brightnessctl
    pulseaudio # for pactl
    webcord
    sums
    wcalc
  ];
}
