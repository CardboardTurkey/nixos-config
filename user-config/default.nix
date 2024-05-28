let
  home-manager = builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/refs/heads/master.tar.gz";

in {
  nix.extraOptions = "tarball-ttl = 0";
  imports = [
    (import "${home-manager}/nixos")

    ./graphical/codium.nix
    ./graphical/gtk.nix
    ./graphical/hyprland.nix
    ./graphical/dunst.nix
    ./graphical/cursor.nix
    ./graphical/obs-studio.nix
    ./graphical/rofi.nix
    ./graphical/eww.nix
    # ./graphical/kanshi.nix

    ./terminal/git.nix
    ./terminal/eza.nix
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
    ./terminal/zoxide.nix
    ./terminal/fzf.nix

    ./other/bluetooth.nix
    ./other/fontconfig.nix
    ./other/gnupg.nix
  ];
  home-manager.users.kiran = _: { home.stateVersion = "22.11"; };
}
