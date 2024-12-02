{ config, lib, ... }:
{
  options.cargo_target_dir = lib.mkOption {
    default = "${config.xdg.cacheHome}/cargo/target";
    type = lib.types.str;
    description = "Global cargo target directory";
  };
  # Consolidate all rust build files into a single directory on disk, to prevent
  # duplicate built dependencies across different projects.
  config.home.file = {
    ".cargo/config.toml" = {
      enable = true;
      text = ''
        [build]
        target-dir = "${config.cargo_target_dir}"
      '';
    };
  };
}
