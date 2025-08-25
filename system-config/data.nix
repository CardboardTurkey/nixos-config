{ config, pkgs, ... }:
let
  influxdb2Port = 8086;
  sigmaDbs = [
    "management"
    "accounting"
    "generative"
  ];
  grantStatements =
    dbNames: username:
    builtins.concatStringsSep "\n" (
      builtins.map (dbName: ''
        psql -c 'GRANT CONNECT ON DATABASE ${dbName} TO ${username}'
        psql -d ${dbName} -c 'GRANT ALL ON SCHEMA public TO ${username}'
      '') dbNames
    );
in
{
  sops.secrets = {
    "influxdb/password" = {
      mode = "0440";
      owner = "influxdb2";
      group = "influxdb2";
    };
    "influxdb/token" = {
      mode = "0440";
      owner = "influxdb2";
      group = "influxdb2";
    };
    "postgres/sigma" = {
      owner = "postgres";
      group = "postgres";
    };
  };

  users.users.grafana.extraGroups = [ "influxdb2" ];
  networking.firewall.allowedTCPPorts = [
    influxdb2Port
    config.services.postgresql.settings.port
  ];

  services = {
    influxdb2 = {
      enable = true;
      settings.http-bind-address = "0.0.0.0:${toString influxdb2Port}";
      # These settings are used only on the VERY FIRST RUN to initialize InfluxDB.
      # They create the initial user, organization, and bucket.
      provision = {
        enable = true;
        initialSetup = {
          username = "admin";
          passwordFile = config.sops.secrets."influxdb/password".path;
          tokenFile = config.sops.secrets."influxdb/token".path;
          organization = "sbuk";
          bucket = "sbuk";
        };
      };
    };
    grafana = {
      enable = true;
      openFirewall = true;
      settings = {
        security.admin_password = "$__file{${config.sops.secrets."influxdb/password".path}}";
        server = {
          http_port = 8999;
          http_addr = "0.0.0.0";
        };
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "InfluxDB";
            type = "influxdb";
            access = "proxy";
            url = "http://localhost:${toString influxdb2Port}";
            jsonData = {
              version = "Flux";
              organization = config.services.influxdb2.provision.initialSetup.organization;
              defaultBucket = config.services.influxdb2.provision.initialSetup.bucket;
              tlsSkipVerify = true;
            };
            secureJsonData = {
              token = "$__file{${config.sops.secrets."influxdb/token".path}}";
            };
          }
        ];
      };
    };
    postgresql = {
      enable = true;
      package = config.psqlPackage;
      authentication = ''
        host all all 172.16.3.0/24 md5
        host all all 172.16.100.0/24 md5
        host all all 172.16.99.0/24 md5
        host all all 172.16.2.0/24 md5
        host all all 172.16.98.0/24 md5
        host all all 172.16.1.0/24 md5
      '';
      ensureUsers = [
        {
          name = "sigma";
          ensureClauses.login = true;
        }
      ];
      ensureDatabases = sigmaDbs;
      enableTCPIP = true;
    };
  };
  systemd = {
    services = {
      postgresql-setup.postStart = ''
        NEW_PASSWORD=$(<"${config.sops.secrets."postgres/sigma".path}");
        psql -c "ALTER USER sigma WITH PASSWORD '$NEW_PASSWORD'";
        ${grantStatements sigmaDbs "sigma"}
      '';
      # Creating the borg back repo:
      #
      # ```console
      # > sudo borg init -e repokey /backup/psql
      # > sudo chown -R postgres /backup/psql
      # ```
      postgresql-backup = {
        enable = true;
        description = "Backup psql data";
        after = [
          "network-online.target"
          "postgres.service"
        ];
        wants = [
          "network-online.target"
          "postgres.service"
        ];
        serviceConfig = {
          Type = "exec";
          EnvironmentFile = config.sops.secrets."backups/postgres".path;
          ExecStart = pkgs.writeScript "psql-backup" ''
            #!${pkgs.bash}/bin/bash
            ${config.services.postgresql.package}/bin/pg_dump -Fc --host=/run/postgresql > /tmp/psql.dump
            ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/psql::$(date -Is)" /tmp/psql.dump
            rm /tmp/psql.dump
          '';
          User = "postgres";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
    timers = {
      postgresql-backup = {
        enable = true;
        unitConfig = {
          Description = "Regularly backup psql data";
          PartOf = [ "postgresql-backup.service" ];
        };
        timerConfig = {
          OnCalendar = "*-*-* 00:00:00";
          Unite = "postgresql-backup.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
