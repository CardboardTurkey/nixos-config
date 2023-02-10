{ lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/CardboardTurkey/home-manager/archive/refs/heads/nushell-keychain.tar.gz";
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
      ./terminal/keychain.nix
      ./terminal/ssh.nix

      ./other/bluetooth.nix
      ./other/fontconfig.nix
      ./other/sops.nix
    ];
  home-manager.users.kiran = _: {
    home.stateVersion = "22.11";
  };
}
