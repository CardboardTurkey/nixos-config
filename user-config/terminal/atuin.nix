{ lib, options, ... }:
{
  programs.atuin =
    {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "http://100.72.92.20:8888";
      };
    }
    # daemon option not present in home-manager release 24.11
    // lib.optionalAttrs (builtins.hasAttr "daemon" options.programs.atuin) {
      daemon.enable = true;
    };
}
