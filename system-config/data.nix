{ config, ... }:
{
  sops.secrets."influxdb/password" = { };
  services.influxdb2 = {
    enable = true;
    provision.initialSetup = {
      username = "admin";
      passwordFile = config.sops.secrets."influxdb/password".path;
    };
  };
  services.grafana = {
    enable = true;
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "influxdb";
          type = "influxdb";
          url = "http://localhost:8086";
        }
      ];
    };
  };
}
