{ pkgs, config, ... }:
let
  ipAddress = "172.16.100.3";
  port = 61967;
  domain = "pad.kiran.smoothbrained.co.uk";
  dataDir = "/var/lib/hedgedoc";
in
{
  sops.secrets = {
    "hedgedoc" = {
      owner = "hedgedoc";
      group = "hedgedoc";
    };
    "backups/hedgedoc" = { };
  };

  networking.firewall.allowedTCPPorts = [ port ];
  services = {
    hedgedoc = {
      enable = true;
      settings = {
        loglevel = "debug";
        port = port;
        host = ipAddress;
        domain = domain;
        protocolUseSSL = true;
        email = false;
        allowEmailRegister = false;
        ldap = {
          url = "ldaps://ldap.smoothbrained.co.uk";
          bindDn = "cn=hedgedoc,ou=sysaccounts,dc=smoothbrained,dc=co,dc=uk";
          searchBase = "ou=people,dc=smoothbrained,dc=co,dc=uk";
          searchFilter = "(uid={{username}})";
          useridField = "uid";
          providerName = "Smoothbrained 🧠";
        };
      };
    };
  };
  systemd = {
    services = {
      hedgedoc.serviceConfig.EnvironmentFile = config.sops.secrets."hedgedoc".path;
      hedgedocBackup = {
        enable = true;
        description = "Backup hedgedoc data";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          Type = "exec";
          EnvironmentFile = config.sops.secrets."backups/hedgedoc".path;
          ExecStart = pkgs.writeScript "hedgedoc-backup" ''
            #!${pkgs.bash}/bin/bash
            ${pkgs.sqlite}/bin/sqlite3 ${dataDir}/db.sqlite ".backup '${dataDir}/backup.sq3'"
            ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/hedgedoc::$(date -Is)" ${dataDir}/backup.sq3 ${dataDir}/uploads
          '';
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
    timers = {
      hedgedocBackup = {
        enable = true;
        unitConfig = {
          Description = "Regularly backup hedgedoc data";
          PartOf = [ "hedgedocBackup.service" ];
        };
        timerConfig = {
          OnCalendar = "*-*-* 00:00:00";
          Unite = "hedgedocBackup.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };

}
