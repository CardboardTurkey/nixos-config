# Create backup:
# 1. `sudo borg init -e repokey /backup/shell` (using password from secrets file)
# 2. `sudo chown -R postgres /backup/shell`
#
# Restore from backup with `sudo -u postgres pg_restore --clean -d atuin --host=/run/postgresql < /tmp/atuin.dump`
#
# Afterwards you might need to re-encrypt:
# `atuin store purge` - this will delete all records in the store that cannot be decrypted with the current key
# `atuin store verify` - verify that the previous operation was successful
# `atuin store push --force` - this will delete all records stored remotely, and then push up local data. Run this on the machine that has been purged
# `atuin store pull --force` - this does the opposite to (3). Delete all local data in the store, and pull from the remote
# `atuin store rebuild history` - ensure your history.db is up to date after all these operations

{
  pkgs,
  config,
  ...
}:
{
  imports = [ ./data.nix ];
  sops.secrets."backups/shell" = {
    owner = "postgres";
    group = "postgres";
  };
  services = {
    atuin = {
      enable = true;
      openFirewall = true;
      openRegistration = true;
      host = "0.0.0.0";
      database.createLocally = true;
    };
  };
  systemd = {
    services = {
      shellBackup = {
        enable = true;
        description = "Backup shell data";
        after = [
          "network-online.target"
          "atuin.service"
        ];
        wants = [
          "network-online.target"
          "atuin.service"
        ];
        serviceConfig = {
          Type = "exec";
          EnvironmentFile = config.sops.secrets."backups/shell".path;
          ExecStart = pkgs.writeScript "shell-backup" ''
            #!${pkgs.bash}/bin/bash
            ${config.services.postgresql.package}/bin/pg_dump -Fc -d atuin --host=/run/postgresql > /tmp/atuin.dump
            ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/shell::$(date -Is)" /tmp/atuin.dump
            rm /tmp/atuin.dump
          '';
          User = "postgres";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
    timers = {
      shellBackup = {
        enable = true;
        unitConfig = {
          Description = "Regularly backup shell data";
          PartOf = [ "shellBackup.service" ];
        };
        timerConfig = {
          OnCalendar = "*-*-* 00:00:00";
          Unite = "shellBackup.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
