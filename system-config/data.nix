{
  config,
  pkgs,
  lib,
  ...
}:
let
  influxdb2Port = 8086;
  sigmaDbs = [
    "management"
    "accounting"
    "generative"
  ];
  ldapUsers = [
    "kostrolenk"
    "aholmes"
    "gatus-kiran"
  ];
  grantStatements =
    dbNames: username:
    builtins.concatStringsSep "\n" (
      builtins.map (dbName: ''
        psql -c 'GRANT CONNECT ON DATABASE ${dbName} TO "${username}"'
        psql -d ${dbName} -c 'GRANT ALL ON SCHEMA public TO "${username}"'
        psql -d ${dbName} -c 'GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "${username}"'
      '') dbNames
    );
  # Trash /var/lib/grafana if your changes aren't taking effect.
  ldapConfigFile = pkgs.writeText "grafana-ldap.toml" ''
    verbose_logging = true
    [[servers]]
    host = "ldap.smoothbrained.co.uk"
    port = 636
    use_ssl = true
    start_tls = false
    ssl_skip_verify = false

    bind_dn = "cn=grafana,ou=sysaccounts,dc=smoothbrained,dc=co,dc=uk"
    bind_password = "$__file{${config.sops.secrets."grafana".path}}"

    timeout = 10

    search_filter = "(uid=%s)"
    search_base_dns = ["ou=people,dc=smoothbrained,dc=co,dc=uk"]

    [servers.attributes]
    member_of = "memberOf"
    email =  "email"
    name = "givenName"
    surname = "sn"
    username = "uid"

    [[servers.group_mappings]]
    group_dn = "cn=sbuk_admins,ou=groups,dc=smoothbrained,dc=co,dc=uk"
    org_role = "Admin"
    grafana_admin = true

    [[servers.group_mappings]]
    group_dn = "*"
    org_role = "Editor"
  '';
  # TODO: restrict filter to ou=people and ou=sysaccounts?
  postgresAuth = ''ldap ldapserver=ldap.smoothbrained.co.uk ldapscheme=ldaps ldapbinddn="cn=postgres,ou=sysaccounts,dc=smoothbrained,dc=co,dc=uk" ldapbindpasswd="${
    builtins.readFile config.sops.secrets."postgres/ldap".path
  }" ldapbasedn="dc=smoothbrained,dc=co,dc=uk" ldapsearchfilter="(|(uid=$username)(cn=$username))"'';
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
    "postgres/ldap" = {
      owner = "postgres";
      group = "postgres";
    };
    "backups/grafana" = {
      owner = "grafana";
      group = "grafana";
    };
    "grafana" = {
      owner = "grafana";
      group = "grafana";
    };
  };

  users.users.grafana.extraGroups = [ "influxdb2" ];
  networking.firewall.allowedTCPPorts = [
    influxdb2Port
    config.services.postgresql.settings.port
  ];

  environment.etc = {
    "pg_hba.conf" = {
      text = ''
        # SBUK auth
        host all all 172.16.3.0/24 ${postgresAuth}
        host all all 172.16.100.0/24 ${postgresAuth}
        host all all 172.16.99.0/24 ${postgresAuth}
        host all all 172.16.2.0/24 ${postgresAuth}
        host all all 172.16.98.0/24 ${postgresAuth}
        host all all 172.16.1.0/24 ${postgresAuth}

        # default value of services.postgresql.authentication
        local all postgres         peer map=postgres
        local all all              peer
        host  all all 127.0.0.1/32 md5
        host  all all ::1/128      md5
      '';
      mode = "0640";
      user = "postgres";
      group = "postgres";
    };
  };

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
        # Should you need to do some debugging:
        # log = {
        #   filters = "ldap:debug";
        #   mode = "console";
        #   level = "debug";
        # };

        # `ini` format seems to limit map depth
        "auth.anonymous".enabled = false;
        "auth.ldap" = {
          enabled = true;
          config_file = "${ldapConfigFile}";
          allow_sign_up = true; # allow the LDAP driver to create new users in the Grafana DB
        };
        users = {
          # Background text for the user field on the login page
          login_hint = "LDAP username";
          password_hint = "LDAP password";
        };
        security.disable_initial_admin_creation = true; # rely only on LDAP for admin users
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
            url = "https://influxdb.b.kiran.smoothbrained.co.uk";
            jsonData = {
              version = "Flux";
              organization = config.services.influxdb2.provision.initialSetup.organization;
              defaultBucket = config.services.influxdb2.provision.initialSetup.bucket;
              withCredentials = true;
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
      package = config.psqlPackage.override {
        ldapSupport = true;
      };
      ensureUsers = builtins.map (user: {
        name = user;
        ensureClauses.login = true;
        ensureDBOwnership = true;
      }) ldapUsers;
      ensureDatabases = sigmaDbs ++ ldapUsers;
      enableTCPIP = true;
      # Need to override this so we can make sure file is not world-readable.
      settings.hba_file = lib.mkForce "/etc/pg_hba.conf";
    };
    gatus.settings = {
      endpoints = [
        {
          name = "Grafana 📊";
          group = "Services";
          url = "https://observe.kiran.smoothbrained.co.uk/api/health";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < ${builtins.toString config.maxResponseTime}"
          ];
        }
        {
          name = "InfluxDB 📉";
          group = "Services";
          url = "https://influxdb.b.kiran.smoothbrained.co.uk/health";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < ${builtins.toString config.maxResponseTime}"
          ];
        }
      ];
      ui.buttons = [
        {
          name = "‣ Grafana";
          link = "https://observe.kiran.smoothbrained.co.uk/";
        }
        {
          name = "‣ InfluxDB";
          link = "https://influxdb.b.kiran.smoothbrained.co.uk/";
        }
      ];
    };
  };
  systemd = {
    services = {
      postgresql-setup.postStart = grantStatements sigmaDbs "kostrolenk";
      grafana.serviceConfig.EnvironmentFile = config.sops.secrets."grafana".path;
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
            BORG_PASSPHRASE="$BORG_PASSPHRASE_LOCAL" ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/psql::$(date -Is)" /tmp/psql.dump
            rm /tmp/psql.dump
          '';
          User = "postgres";
        };
        wantedBy = [ "multi-user.target" ];
      };
      grafana-backup = {
        enable = true;
        description = "Backup grafana data";
        after = [
          "network-online.target"
          "grafana.service"
        ];
        wants = [
          "network-online.target"
          "grafana.service"
        ];
        serviceConfig = {
          Type = "exec";
          EnvironmentFile = config.sops.secrets."backups/grafana".path;
          ExecStart = pkgs.writeScript "grafana-backup" ''
            #!${pkgs.bash}/bin/bash
            BORG_PASSPHRASE="$BORG_PASSPHRASE_LOCAL" ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/grafana::$(date -Is)" /var/lib/grafana
          '';
          User = "grafana";
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
      grafana-backup = {
        enable = true;
        unitConfig = {
          Description = "Regularly backup grafana data";
          PartOf = [ "grafana-backup.service" ];
        };
        timerConfig = {
          OnCalendar = "*-*-* 00:00:00";
          Unite = "grafana-backup.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
