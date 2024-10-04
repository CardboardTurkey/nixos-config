let
  full-env = [
    ./graphical/gtk.nix
    ./graphical/hyprland.nix
    ./graphical/dunst.nix
    ./graphical/obs-studio.nix
    ./graphical/rofi.nix
    ./graphical/eww
    ./graphical/hyprlock.nix
    ./graphical/codium.nix
    ./graphical/btop.nix

    ./terminal/git.nix
    ./terminal/eza.nix
    ./terminal/starship.nix
    ./terminal/emulator.nix
    ./terminal/tmux.nix
    ./terminal/zsh.nix
    ./terminal/nushell.nix
    ./terminal/neovim.nix
    ./terminal/bat.nix
    ./terminal/direnv.nix
    ./terminal/ssh.nix
    ./terminal/zoxide.nix
    ./terminal/fzf.nix
    ./terminal/hyperfine.nix

    ./other/fontconfig.nix
    ./other/sops_config.nix
    ./other/batsignal.nix
    ./other/catppuccin.nix
  ];
in {
  # For zsh compeletion (apparently)
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;

  # Needed by gtk?
  programs.dconf.enable = true;

  # Also need hyprland from system-config

  # Maybe move this into system config?
  catppuccin = {
    enable = true;
    flavor = "frappe";
  };

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
