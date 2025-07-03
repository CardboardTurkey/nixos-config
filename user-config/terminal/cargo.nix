{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.cargoTargetDir = lib.mkOption {
    default = "${config.xdg.cacheHome}/cargo/target";
    type = lib.types.str;
    description = "Global cargo target directory";
  };
  # Consolidate all rust build files into a single directory on disk, to prevent
  # duplicate built dependencies across different projects.
  config.home.file = {
    ".cargo/config.toml" = {
      enable = true;
      source = (pkgs.formats.toml { }).generate "cargo-config.toml" {
        build.target-dir = config.cargoTargetDir;
        net.git-fetch-with-cli = true;
      };
    };
  };
}
