{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [ trash-cli ];
    shellAliases = {
      rm = "echo Do not use rm; false";
    };
  };
  systemd.user.timers = {
    empty-trash = {
      enable = true;
      unitConfig = {
        Description = "Regularly delete trashed files";
        PartOf = [ "empty-trash.service" ];
      };
      timerConfig = {
        OnUnitActiveSec = 60 * 60 * 48; # every 48 hours
      };
      wantedBy = [ "timers.target" ];
    };
  };
  systemd.user.services = {
    empty-trash = {
      enable = true;
      unitConfig = {
        Description = "Delete old trashed files";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.trash-cli}/bin/trash-empty 50";
      };
    };
  };
}
