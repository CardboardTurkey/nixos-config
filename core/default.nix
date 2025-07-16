{
  lib,
  ...
}:

with lib;
with types;
{
  imports = [
    ./nord.nix
    ./keys.nix
    ./hardware.nix
    ./rice.nix
  ];

  options = {
    hostname = mkOption {
      default = "";
      type = uniq str;
      description = "Network hostname";
    };
    allowed_unfree = mkOption {
      default = [ ];
      type = listOf str;
      description = "Allowed unfree packages";
    };
    root = mkOption {
      default = "";
      type = with types; uniq str;
      description = "Root partition id";
    };
    emulator = mkOption {
      default = "kitty";
      type = str;
      description = "Which console emulator to use";
    };
    file_manager = mkOption {
      default = "pcmanfm";
      type = str;
      description = "Which file manager to use";
    };
    atuinAddress = lib.mkOption {
      default = "0.0.0.0";
      type = lib.types.str;
      description = "IP address for atuin server";
    };
    userModules = mkOption {
      default = [
        "graphical/gtk.nix"
        "graphical/hyprland.nix"
        "graphical/obs-studio.nix"
        "graphical/rofi.nix"
        "graphical/hyprlock.nix"
        "graphical/hyprpaper.nix"
        "graphical/codium.nix"
        "graphical/btop.nix"
        "graphical/firefox.nix"
        "graphical/cursor.nix"
        "graphical/hyprpanel.nix"

        "terminal/atuin.nix"
        "terminal/git.nix"
        "terminal/eza.nix"
        "terminal/starship.nix"
        "terminal/emulator.nix"
        "terminal/tmux.nix"
        "terminal/zsh.nix"
        "terminal/nushell.nix"
        "terminal/neovim.nix"
        "terminal/helix.nix"
        "terminal/direnv.nix"
        "terminal/ssh.nix"
        "terminal/zoxide.nix"
        "terminal/fzf.nix"
        "terminal/less.nix"
        "terminal/cargo.nix"
        "terminal/gh.nix"
        "terminal/misc.nix"

        "other/fontconfig.nix"
        "other/sops_config.nix"
        "other/batsignal.nix"
        "other/catppuccin.nix"
        "other/mime_apps.nix"
      ];
      type = listOf str;
      description = "Home manager modules";
    };
  };
}
