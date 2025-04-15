{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
with types;
{
  imports = [
    ./nord.nix
    ./keys.nix
  ];

  options = {
    hostname = mkOption {
      default = "";
      type = uniq str;
      description = "Network hostname";
    };
    font_size_small = mkOption {
      default = 12.0;
      type = float;
      description = "Small font size";
    };
    font_size_medium = mkOption {
      default = 15.0;
      type = float;
      description = "Medium font size";
    };
    font_size_large = mkOption {
      default = 19.0;
      type = float;
      description = "Large font size";
    };
    allowed_unfree = mkOption {
      default = [ ];
      type = listOf str;
      description = "Allowed unfree packages";
    };
    pics = mkOption {
      default = {
        wallpaper = builtins.toString (
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master/crane.png";
            hash = "sha256-h3C531cWmp5w262ReqjHzqZwjOVEpS8UtSOPNApyGfs=";
          }
        );
        lock = builtins.toString (
          pkgs.fetchurl {
            url = "https://images.pexels.com/photos/681467/pexels-photo-681467.jpeg";
            hash = "sha256-ZZOoBai9omKebZfHuJ204uw7EmKNv5K4iUCNE4PCXhY=";
          }
        );
        avatar = builtins.toString (
          pkgs.fetchurl {
            url = "https://i.imgur.com/0hm6hFw.png";
            hash = "sha256-B6LOBD2eZHGYxAcNRWuXHDKJlq2lcrfgFUIzdRWIUGU=";
          }
        );
      };
      type = attrs;
      description = "Paths to wallpapers";
    };
    monitor_scale = mkOption {
      default = 1;
      type = int;
      description = "For when you need to rescale for monitor size";
    };
    root = mkOption {
      default = "";
      type = with types; uniq str;
      description = "Root partition id";
    };
    flavour = mkOption {
      default = "frappe";
      type = str;
      description = "Within a given theme you might choose a flavour";
    };
    accent = mkOption {
      default = "teal";
      type = str;
      description = "Within a given theme you might choose an accent colour";
    };
    theme = mkOption {
      default =
        (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${config.flavour}.colors;
      type = attrs;
      description = "The chosen colour theme for this build";
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
      default = "100.72.92.20";
      type = lib.types.str;
      description = "IP address for atuin server";
    };
    userModules = mkOption {
      default = [
        "graphical/gtk.nix"
        "graphical/hyprland.nix"
        "graphical/dunst.nix"
        "graphical/obs-studio.nix"
        "graphical/rofi.nix"
        "graphical/eww"
        "graphical/hyprlock.nix"
        "graphical/hyprpaper.nix"
        "graphical/codium.nix"
        "graphical/btop.nix"
        "graphical/firefox.nix"
        "graphical/cursor.nix"

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
