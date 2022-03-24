{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./graphical/autorandr.nix
      ./graphical/codium.nix
      ./graphical/gtk.nix
      ./graphical/i3.nix
      ./graphical/lockscreen.nix
      ./graphical/picom.nix
      ./graphical/polybar.nix
      ./graphical/rofi.nix

      ./terminal/git.nix
      ./terminal/misc.nix
      ./terminal/starship.nix
      ./terminal/alacritty.nix
      ./terminal/tmux.nix
      ./terminal/zsh.nix
    ];
}