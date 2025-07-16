{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with types;
{
  options = {
    fontSizeSmall = mkOption {
      default = 12.0;
      type = float;
      description = "Small font size";
    };
    fontSizeMedium = mkOption {
      default = 15.0;
      type = float;
      description = "Medium font size";
    };
    fontSizeLarge = mkOption {
      default = 19.0;
      type = float;
      description = "Large font size";
    };
    pics = mkOption {
      default = {
        wallpaper = builtins.toString (
          pkgs.fetchurl {
            url = "https://unsplash.com/photos/p-kyrENoi6U/download";
            hash = "sha256-UE6dDLRxLlSSHZzwMlaUC9PZ8WTvv/CFcalRoQu5Z7o=";
          }
        );
        lock = builtins.toString (
          pkgs.fetchurl {
            url = "https://unsplash.com/photos/p-kyrENoi6U/download";
            hash = "sha256-UE6dDLRxLlSSHZzwMlaUC9PZ8WTvv/CFcalRoQu5Z7o=";
          }
        );
      };
      type = attrs;
      description = "Paths to wallpapers";
    };
    monitorScale = mkOption {
      default = 1;
      type = int;
      description = "For when you need to rescale for monitor size";
    };
    gapsOut = mkOption {
      default = 10;
      type = int;
      description = "Outer gaps around windows";
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
    cornerRadius = mkOption {
      default = 14;
      type = int;
      description = "Radius window/widget corners";
    };
  };
}
