# Setup
#
# The connector requires a client ID and secret. It seems there's no
# declarative way to set this up.
#
# Instead, create a user and an org manually. Then go to
# Admin console > Settings > Organization info. You can find `client_id` and
# `client_secret` under "View API key".
{ config, ... }:
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
  sops.secrets =
    secretPermissions "vaultwarden" [
      "vaultwarden/env"
    ]
    // secretPermissions "bwdc" [
      "vaultwarden/ldap"
      "vaultwarden/client_secret"
      "vaultwarden/client_id"
    ];

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
      backupDir = "/var/backup/vaultwarden";
    };
    bitwarden-directory-connector-cli = {
      enable = true;
      domain = "https://pass.kiran.smoothbrained.co.uk";
      ldap = {
        rootPath = "dc=smoothbrained,dc=co,dc=uk";
        port = 636;
        ssl = true;
        hostname = "ldap.smoothbrained.co.uk";
        username = "cn=vaultwarden,ou=sysaccounts,dc=smoothbrained,dc=co,dc=uk";
      };
      secrets = {
        ldap = config.sops.secrets."vaultwarden/ldap".path;
        bitwarden = {
          client_path_id = config.sops.secrets."vaultwarden/client_id".path;
          client_path_secret = config.sops.secrets."vaultwarden/client_secret".path;
        };
      };
      sync = {
        users = true;
        userPath = "ou=people";
        overwriteExisting = true;
        groups = true;
        removeDisabled = true;
      };
    };
  };
}
