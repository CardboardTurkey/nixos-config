{
  osConfig,
  # lib,
  # options,
  ...
}:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      filter_mode = "directory";
      sync_frequency = "5m";
      sync_address = "http://${osConfig.atuinAddress}:8888";
      history_filter = [ ".*[a-zA-Z]+-[a-zA-Z]+-[a-zA-Z]+.*" ];
      # daemon.enable = true;
    };
  };
}
