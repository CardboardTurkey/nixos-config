{ pkgs, ... }:

{
  imports = [ ./pkgs_mine/dirtygit/module.nix ];
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
    python3
    gimp
    ffmpeg
    local.rustup
    local.pyup
  ];
}
