{ pkgs, ... }:

{
  nixpkgs.overlays = [ (self: super: { local = import ./pkgs_mine { pkgs = super; }; }) ];

  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    quasselClient
    local.scripts
    local.logiops
    feh
    arandr
    brightnessctl
    flameshot
    signal-desktop
    xorg.xev
    pavucontrol
    python
    gimp
    ffmpeg
  ];
}
