{ config, ... }:
let
  influxdb2Port = 8086;
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
  };

  users.users.grafana.extraGroups = [ "influxdb2" ];
  networking.firewall.allowedTCPPorts = [ influxdb2Port ];

  services.influxdb2 = {
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

  services.grafana = {
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
}
