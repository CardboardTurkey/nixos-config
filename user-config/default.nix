{ lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/refs/heads/master.tar.gz";
in

{
  nix.extraOptions = "tarball-ttl = 0";
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
      ./graphical/cursor.nix
      ./graphical/obs-studio.nix
      ./graphical/autorandr.nix
      ./graphical/i3.nix
      ./graphical/picom.nix
      ./graphical/lockscreen.nix
      ./graphical/polybar.nix
      ./graphical/rofi.nix
      ./graphical/wallpaper.nix

      ./terminal/git.nix
      ./terminal/lsd.nix
      ./terminal/starship.nix
      ./terminal/alacritty.nix
      ./terminal/tmux.nix
      ./terminal/zsh.nix
      ./terminal/nushell.nix
      ./terminal/neovim.nix
      ./terminal/bat.nix
      ./terminal/direnv.nix
      ./terminal/nix_index.nix
      ./terminal/ssh.nix

      ./other/bluetooth.nix
      ./other/fontconfig.nix
      ./other/sops.nix
      ./other/gnupg.nix
    ];
  home-manager.users.kiran = _: {
    home.stateVersion = "22.11";
  };
}
