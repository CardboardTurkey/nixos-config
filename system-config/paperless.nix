{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ config.services.paperless.port ];
  sops.secrets =
    let
      ownership = user: {
        owner = user;
        group = user;
      };
    in
    {
      "paperless/env" = ownership config.services.paperless.user;
      "paperless/admin_password" = ownership config.services.paperless.user;
      "backups/paperless/local" = { };
    };
  services = {
    postgresql = {
      ensureDatabases = [ "paperless" ];
      ensureUsers = [
        {
          name = config.services.paperless.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };
    borgbackup.jobs = {
      localPaperlessBackup = {
        paths = "/var/lib/paperless";
        repo = "/backup/paperless";
        doInit = false;
        encryption = {
          mode = "repokey";
          passCommand = "cat ${config.sops.secrets."backups/paperless/local".path}";
        };
        compression = "auto,lzma";
        startAt = "daily";
        removableDevice = true;
        prune.keep = {
          daily = 7;
          weekly = 4;
          monthly = 6;
          yearly = 1;
        };
      };
    };
    paperless = {
      enable = true;
      domain = "bureau.kiran.smoothbrained.co.uk";
      address = config.sbukAddress;
      settings = {
        PAPERLESS_DBHOST = "postgres.kiran.smoothbrained.co.uk";
        PAPERLESS_APP_TITLE = "SBUK document bureau";
        PAPERLESS_APP_LOGO = "https://gitlab.com/api/v4/projects/74365490/packages/generic/sbuk-assets/1.0.2/imgs/logo_512x512.png";
        PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
      };
      configureTika = true;
      environmentFile = config.sops.secrets."paperless/env".path;
      passwordFile = config.sops.secrets."paperless/admin_password".path;
    };
  };
}
