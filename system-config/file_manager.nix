{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs."${config.file_manager}" ];
  services.gvfs.enable = true;
}
