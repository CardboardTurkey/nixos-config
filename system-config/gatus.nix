{ config, ... }:
{
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
        # custom-css = ''
        #   a {
        #     font: bold 11px Arial;
        #     text-decoration: none;
        #     background-color: #EEEEEE;
        #     color: #333333;
        #     padding: 2px 6px 2px 6px;
        #     border-top: 1px solid #CCCCCC;
        #     border-right: 1px solid #333333;
        #     border-bottom: 1px solid #333333;
        #     border-left: 1px solid #CCCCCC;
        #   }
        #   a:link, a:visited {
        #     font: bold 11px Arial;
        #     text-decoration: none;
        #     background-color: #EEEEEE;
        #     color: #333333;
        #     padding: 2px 6px 2px 6px;
        #     border-top: 1px solid #CCCCCC;
        #     border-right: 1px solid #333333;
        #     border-bottom: 1px solid #333333;
        #     border-left: 1px solid #CCCCCC;
        #     display: inline-block; /* This can help with consistent padding and borders */
        #   }

        #   a:hover {
        #     background-color: #DDDDDD;
        #   }

        #   a:active {
        #     border-top: 1px solid #333333;
        #     border-left: 1px solid #333333;
        #   }
        # '';
      };
      endpoints = [
        {
          name = "Portfolio";
          group = "Websites";
          url = "https://kiran.ostrolenk.co.uk/";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 300"
          ];
        }
        {
          name = "Unite4Palestine";
          group = "Websites";
          url = "https://www.unite4palestine.co.uk/";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 300"
          ];
        }
        {
          name = "Lard will tear us apart";
          group = "Websites";
          url = "https://www.lardwilltearusapart.co.uk/";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 300"
          ];
        }
      ];
    };
  };
}
