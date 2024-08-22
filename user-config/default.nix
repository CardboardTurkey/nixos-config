let
  full-env = [
    ./graphical/codium.nix
    ./graphical/gtk.nix
    ./graphical/hyprland.nix
    ./graphical/dunst.nix
    ./graphical/cursor.nix
    ./graphical/obs-studio.nix
    ./graphical/rofi.nix
    ./graphical/eww.nix
    ./graphical/hyprlock.nix

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
    ./terminal/ssh.nix
    ./terminal/zoxide.nix
    ./terminal/fzf.nix

    ./other/fontconfig.nix
    ./other/sops_config.nix
    ./other/batsignal.nix
  ];
in {
  services.lorri.enable = true;

  # For zsh compeletion (apparently)
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;

  # Needed by gtk?
  programs.dconf.enable = true;

  # Also need hyprland from system-config

  home-manager = {
    users = {
      kiran = {
        home.stateVersion = "22.11";
        imports = full-env;
      };
    };
    useGlobalPkgs = true;
  };
}
