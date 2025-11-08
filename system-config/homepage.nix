{ config, ... }:
{
  services = {
    glances.enable = true;
    homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "localhost:${builtins.toString config.services.homepage-dashboard.listenPort},127.0.0.1:${builtins.toString config.services.homepage-dashboard.listenPort},${config.sbukAddress}:${builtins.toString config.services.homepage-dashboard.listenPort}";
      settings = {
        title = "Kiran SBUK";
        description = "The services hosted on Kiran's SBUK box";
        hideVersion = true;
        background = "https://unsplash.com/photos/p-kyrENoi6U/download";
        cardBlur = "md";
        favicon = "https://gitlab.com/api/v4/projects/74365490/packages/generic/sbuk-assets/1.0.2/imgs/favicon-48.png";
      };
      widgets = [
        {
          logo.icon = "https://gitlab.com/smoothbrained-uk/public-assets/-/raw/master/logo.svg";
          glances = {
            url = "http://localhost:${builtins.toString config.services.glances.port}";
            version = 4; # required only if running glances v4 or higher, defaults to 3
            cpu = true; # optional, enabled by default, disable by setting to false
            mem = true; # optional, enabled by default, disable by setting to false
            cputemp = true; # disabled by default
            uptime = true; # disabled by default
            disk = "/"; # disabled by default, use mount point of disk(s) in glances. Can also be a list (see below)
            diskUnits = "bytes"; # optional, bytes (default) or bbytes. Only applies to disk
          };
        }
      ];
      services = [
        {
          Cloud = [
            {
              "Hedgedoc" = {
                icon = "hedgedoc";
                href = "https://pad.kiran.smoothbrained.co.uk";
                description = "Collaborative markdown editor.";
              };
            }
          ];
        }
        {
          Monitoring = [
            {
              Gatus = {
                icon = "gatus";
                href = "https://kiran.smoothbrained.co.uk";
                description = "Health status of Kiran SBUK services";
                widget = {
                  type = "gatus";
                  url = "https://kiran.smoothbrained.co.uk";
                };
              };
            }
            {
              Graphana = {
                icon = "grafana";
                href = "https://observe.kiran.smoothbrained.co.uk";
                description = "Data dashboards.";
              };
            }
          ];
        }
      ];
    };
  };
}
