{ ... }:

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
      ./graphical/dunst.nix
      ./graphical/wallpaper.nix

      ./terminal/git.nix
      ./terminal/misc.nix
      ./terminal/starship.nix
      ./terminal/alacritty.nix
      ./terminal/tmux.nix
      ./terminal/zsh.nix
      ./terminal/neovim.nix

      ./other/bluetooth.nix
      ./other/fontconfig.nix
    ];
}
