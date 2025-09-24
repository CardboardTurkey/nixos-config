{ config, lib, ... }:
{

  options.maxResponseTime = lib.mkOption {
    default = 600;
    type = lib.types.int;
    description = "Maximum response time in health checks";
  };

  config = {
    sops.secrets.gatus = { };

    services.gatus = {
      enable = true;
      openFirewall = true;
      environmentFile = config.sops.secrets."gatus".path;
      settings = {
        web.port = 9194;
        storage = {
          type = "postgres";
          caching = true;
          path = "postgres://gatus-kiran:\${POSTGRES_PASSWORD}@postgres.kiran.smoothbrained.co.uk/gatus-kiran?sslmode=disable";
        };
        ui = {
          title = "Kiran SBUK";
          description = "Kiran's services and websites hosted on the SBUK infra.";
          header = "Kiran's SBUK services and websites";
          logo = "https://gitlab.com/smoothbrained-uk/public-assets/-/raw/master/logo.svg";
        };
        endpoints = [
          {
            name = "Portfolio";
            group = "Websites";
            url = "https://kiran.ostrolenk.co.uk/";
            interval = "5m";
            conditions = [
              "[STATUS] == 200"
              "[RESPONSE_TIME] < ${builtins.toString config.maxResponseTime}"
            ];
          }
          {
            name = "Unite4Palestine";
            group = "Websites";
            url = "https://www.unite4palestine.co.uk/";
            interval = "5m";
            conditions = [
              "[STATUS] == 200"
              "[RESPONSE_TIME] < ${builtins.toString config.maxResponseTime}"
            ];
          }
          {
            name = "Lard will tear us apart";
            group = "Websites";
            url = "https://www.lardwilltearusapart.co.uk/";
            interval = "5m";
            conditions = [
              "[STATUS] == 200"
              "[RESPONSE_TIME] < ${builtins.toString config.maxResponseTime}"
            ];
          }
        ];
      };
    };
  };
}
