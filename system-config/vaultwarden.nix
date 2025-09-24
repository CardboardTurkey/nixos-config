# Setup
#
# The connector requires a client ID and secret. It seems there's no
# declarative way to set this up.
#
# Instead, create a user and an org manually. Then go to
# Admin console > Settings > Organization info. You can find `client_id` and
# `client_secret` under "View API key".
{
  config,
  pkgs,
  ...
}:
let
  secretPermissions =
    user: secrets:
    builtins.listToAttrs (
      builtins.map (secret: {
        name = secret;
        value = {
          owner = user;
          group = user;
        };
      }) secrets
    );
in
{
  sops.secrets = secretPermissions "vaultwarden" [
    "vaultwarden/env"
    "backups/vaultwarden"
  ]
  # // secretPermissions "bwdc" [
  #   "vaultwarden/ldap"
  #   "vaultwarden/client_secret"
  #   "vaultwarden/client_id"
  # ]
  ;

  networking.firewall.allowedTCPPorts = [ 9876 ];
  services = {
    vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets."vaultwarden/env".path;
      dbBackend = "sqlite";
      config = {
        domain = "https://pass.kiran.smoothbrained.co.uk";
        signupsAllowed = true;
        rocketAddress = "0.0.0.0";
        rocketPort = 9876;
      };
    };

    gatus.settings = {
      endpoints = [
        {
          name = "Vaultwarden 🔒";
          group = "Services";
          url = "https://pass.kiran.smoothbrained.co.uk/alive";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < ${builtins.toString config.maxResponseTime}"
          ];
        }
      ];
      ui.buttons = [
        {
          name = "‣ Vaultwarden";
          link = "https://pass.kiran.smoothbrained.co.uk/";
        }
      ];
    };

    # Use this if you want to try LDAP sync
    # bitwarden-directory-connector-cli = {
    #   enable = true;
    #   domain = "https://pass.kiran.smoothbrained.co.uk";
    #   ldap = {
    #     rootPath = "dc=smoothbrained,dc=co,dc=uk";
    #     port = 636;
    #     ssl = true;
    #     hostname = "ldap.smoothbrained.co.uk";
    #     username = "cn=vaultwarden,ou=sysaccounts,dc=smoothbrained,dc=co,dc=uk";
    #   };
    #   secrets = {
    #     ldap = config.sops.secrets."vaultwarden/ldap".path;
    #     bitwarden = {
    #       client_path_id = config.sops.secrets."vaultwarden/client_id".path;
    #       client_path_secret = config.sops.secrets."vaultwarden/client_secret".path;
    #     };
    #   };
    #   sync = {
    #     users = true;
    #     userPath = "ou=people";
    #     overwriteExisting = true;
    #     groups = true;
    #     removeDisabled = true;
    #   };
    # };
  };
  systemd = {
    services = {
      vaultwarden-backup = {
        enable = true;
        description = "Backup vaultwarden data";
        after = [
          "network-online.target"
          "vaultwarden.service"
        ];
        wants = [
          "network-online.target"
          "vaultwarden.service"
        ];
        serviceConfig = {
          Type = "exec";
          EnvironmentFile = config.sops.secrets."backups/vaultwarden".path;
          ExecStart = pkgs.writeScript "vaultwarden-backup" ''
            #!${pkgs.bash}/bin/bash
            BORG_PASSPHRASE="$BORG_PASSPHRASE_LOCAL" ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/vaultwarden::$(date -Is)" /var/lib/vaultwarden
          '';
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
    timers = {
      vaultwarden-backup = {
        enable = true;
        unitConfig = {
          Description = "Regularly backup vaultwarden data";
          PartOf = [ "vaultwarden-backup.service" ];
        };
        timerConfig = {
          OnCalendar = "*-*-* 00:00:00";
          Unite = "vaultwarden-backup.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
