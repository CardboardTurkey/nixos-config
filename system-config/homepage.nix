{ config, ... }:
{
  sops.secrets.homepage = {
    # owner = "homepage-dashboard";
    # group = "homepage-dashboard";
  };

  services = {
    glances.enable = true;
    homepage-dashboard = {
      enable = true;
      openFirewall = true;
      environmentFile = config.sops.secrets.homepage.path;
      allowedHosts = "localhost:${builtins.toString config.services.homepage-dashboard.listenPort},127.0.0.1:${builtins.toString config.services.homepage-dashboard.listenPort},${config.sbukAddress}:${builtins.toString config.services.homepage-dashboard.listenPort},kiran.smoothbrained.co.uk";
      settings = {
        title = "Kiran SBUK";
        description = "The services hosted on Kiran's SBUK box";
        hideVersion = true;
        background = "https://lh3.googleusercontent.com/pw/AP1GczMciRvT57Tt_GPezyK-ABhV1mROI8_ELgwn-9iggdUQGZ0nhMc5e9fltKk5pdV6FYVCS9urncOPxNqKzCWLJ7U3KqAy9j5Y8dwOriHkhFMM_-0-la_VZIrpxEeWue15KRaf_Y9uyZ1PtUtdIr4yiY1z3g=w3452-h1942-s-no?authuser=0";
        cardBlur = "xl";
        favicon = "https://gitlab.com/api/v4/projects/74365490/packages/generic/sbuk-assets/1.0.2/imgs/favicon-48.png";
        layout = {
          Monitoring = {
            style = "row";
            columns = "2";
          };
          Cloud = {
            style = "row";
            columns = "2";
          };
        };
      };
      widgets = [
        {
          logo.icon = "https://gitlab.com/smoothbrained-uk/public-assets/-/raw/master/logo.svg";
        }
        {
          greeting = {
            text_size = "2xl";
            text = "Kiran's SBUK web services";
          };
        }
        {
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
          Monitoring = [
            {
              Gatus = rec {
                icon = "gatus";
                href = "https://status.kiran.smoothbrained.co.uk";
                description = "Health status of Kiran SBUK services";
                widget = {
                  type = "gatus";
                  url = href;
                };
              };
            }
            {
              Graphana =
                let
                  url = "https://observe.kiran.smoothbrained.co.uk";
                in
                {
                  icon = "grafana";
                  href = url;
                  description = "Data dashboards.";
                  widget = {
                    type = "grafana";
                    version = 2; # optional, default is 1
                    inherit url;
                    username = "{{HOMEPAGE_VAR_GRAFANA_USERNAME}}";
                    password = "{{HOMEPAGE_VAR_GRAFANA_PASSWORD}}";
                  };
                };
            }
          ];
        }
        {
          Cloud = [
            {
              "Hedgedoc" = rec {
                icon = "hedgedoc";
                href = "https://${ping}";
                description = "Collaborative markdown editor.";
                ping = "pad.kiran.smoothbrained.co.uk";
              };
            }
            {
              "Vaultwarden" = rec {
                icon = "vaultwarden";
                href = "https://${ping}";
                description = "Password manager";
                ping = "pass.kiran.smoothbrained.co.uk";
              };
            }
            {
              "InfluxDB" = rec {
                icon = "influxdb";
                href = "https://${ping}";
                description = "Time series database";
                ping = "influxdb.b.kiran.smoothbrained.co.uk";
              };
            }
            {
              "Atuin" = rec {
                icon = "atuin";
                href = "https://${ping}";
                description = "Distributed shell history";
                ping = "atuin.kiran.smoothbrained.co.uk";
              };
            }
          ];
        }
      ];
    };
  };
}
