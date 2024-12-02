{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.dirtygit;
in
{
  options = {
    services.dirtygit = {
      enable = mkEnableOption "dirtygit";
    };
  };
  config = mkIf cfg.enable {
    systemd.user.services.dirtygit = {
      description = "Dirtygit daemon";
      enable = true;
      wantedBy = [ "default.target" ];
      # environment =  { RUST_LOG = "debug"; };
      path = [ pkgs.git ];
      serviceConfig = {
        ExecStart = "${pkgs.local.dirtygit}/bin/dirtygitd";
        RestartSec = 3;
        Restart = "always";
      };
    };
  };
}
