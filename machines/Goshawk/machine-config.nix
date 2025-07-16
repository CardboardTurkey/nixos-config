{
  hostname = "Goshawk";
  userModules = [
    "graphical/gtk.nix"
    "graphical/hyprland.nix"
    "graphical/dunst.nix"
    "graphical/rofi.nix"
    "graphical/hyprlock.nix"
    "graphical/codium.nix"
    "graphical/btop.nix"

    "terminal/git.nix"
    "terminal/eza.nix"
    "terminal/starship.nix"
    "terminal/emulator.nix"
    "terminal/tmux.nix"
    "terminal/zsh.nix"
    "terminal/nushell.nix"
    "terminal/neovim.nix"
    "terminal/bat.nix"
    "terminal/direnv.nix"
    "terminal/ssh.nix"
    "terminal/zoxide.nix"
    "terminal/fzf.nix"
    "terminal/hyperfine.nix"
    "terminal/cargo.nix"

    "other/fontconfig.nix"
    "other/sops_config.nix"
    "other/catppuccin.nix"
  ];
}
