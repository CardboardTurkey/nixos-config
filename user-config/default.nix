{ lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in

{
  imports = 
    [
      (import "${home-manager}/nixos")

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
      ./terminal/starship.nix
      ./terminal/alacritty.nix
      ./terminal/tmux.nix
      ./terminal/zsh.nix
      ./terminal/neovim.nix
      ./terminal/bat.nix
      ./terminal/direnv.nix
      ./terminal/nix_index.nix
      ./terminal/keychain.nix
      ./terminal/ssh.nix

      ./other/bluetooth.nix
      ./other/fontconfig.nix
    ];
  home-manager.users.kiran = { ... }: {
    home.stateVersion = "22.11";
  };
}
