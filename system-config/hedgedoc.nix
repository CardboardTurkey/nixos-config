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
    "hedgedoc_ssh" = {
      owner = "hedgedoc";
      group = "hedgedoc";
    };
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
  # systemd = {
  #   services = {
  #     hedgedoc.serviceConfig.EnvironmentFile = config.sops.secrets."hedgedoc".path;
  #     # Annoyance: first times this runs borg will question the lack of encryption.
  #     # Annoyance: root user needs to approve ssh host key
  #     hedgedocBackup = {
  #       enable = true;
  #       description = "Backup hedgedoc data";
  #       after = [ "network-online.target" ];
  #       wants = [ "network-online.target" ];
  #       serviceConfig = {
  #         Type = "exec";
  #         ExecStart = pkgs.writeScript "hedgedoc-backup" ''
  #           #!${pkgs.bash}/bin/bash
  #           archiveName="Kestrel-hedgedoc-$(${pkgs.coreutils}/bin/date +%Y-%m-%dT%H:%M:%S)"
  #           ${pkgs.sqlite}/bin/sqlite3 ${dataDir}/db.sqlite ".backup '${dataDir}/backup.sq3'"
  #           ${pkgs.borgbackup}/bin/borg create --rsh 'ssh -i ${
  #             config.sops.secrets."hedgedoc_ssh".path
  #           }' --compression auto,zstd "kostrolenk@crista.service.eyegog.co.uk:/home/kostrolenk/backups/hedgedoc::$archiveName" ${dataDir}/uploads ${dataDir}/backup.sq3
  #         '';
  #       };
  #       wantedBy = [ "multi-user.target" ];
  #     };
  #   };
  #   timers = {
  #     hedgedocBackup = {
  #       enable = true;
  #       unitConfig = {
  #         Description = "Regularly backup hedgedoc data";
  #         PartOf = [ "hedgedocBackup.service" ];
  #       };
  #       timerConfig = {
  #         OnCalendar = "*-*-* 00:00:00";
  #         Unite = "hedgedocBackup.service";
  #       };
  #       wantedBy = [ "timers.target" ];
  #     };
  #   };
  # };

}
