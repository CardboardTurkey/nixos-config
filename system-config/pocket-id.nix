# First login post setup is a little fiddly. All users will have been created
# from LDAP. You then need to create a shell with all the env vars from the
# pocket-id instance set. You can then run `pocket-id one-time-access-token <user
# name or email>` and follow the link.
{ pkgs, config, ... }:
{

  sops.secrets = {
    pocket_id = {
      owner = config.services.pocket-id.user;
      group = config.services.pocket-id.user;
    };
    "backups/pocket-id" = {
      owner = config.services.pocket-id.user;
      group = config.services.pocket-id.user;
    };
  };
  networking.firewall.allowedTCPPorts = [ config.services.pocket-id.settings.PORT ];
  services = {
    postgresql = {
      ensureDatabases = [ "pocket-id-kiran" ];
      ensureUsers = [
        {
          name = "pocket-id-kiran";
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };
    pocket-id = {
      enable = true;
      settings = {
        # General
        TRUST_PROXY = true;
        APP_URL = "https://id.kiran.smoothbrained.co.uk";
        DB_PROVIDER = "postgres";
        HOST = config.sbukAddress;
        KEYS_STORAGE = "database";
        PORT = 1411;

        # LDAP
        UI_CONFIG_DISABLED = "true";
        LDAP_ENABLED = "true";
        LDAP_URL = "ldaps://ldap.smoothbrained.co.uk";
        LDAP_BIND_DN = "cn=pocket-id-kiran,ou=sysaccounts,dc=smoothbrained,dc=co,dc=uk";
        LDAP_BASE = "ou=people,dc=smoothbrained,dc=co,dc=uk";
        LDAP_USER_SEARCH_FILTER = "(uid=*)";
        LDAP_USER_GROUP_SEARCH_FILTER = "(objectClass=groupOfNames)";
        LDAP_SKIP_CERT_VERIFY = "false";
        LDAP_SOFT_DELETE_USERS = "false";
        LDAP_ATTRIBUTE_USER_UNIQUE_IDENTIFIER = "entryUUID";
        LDAP_ATTRIBUTE_USER_USERNAME = "uid";
        LDAP_ATTRIBUTE_USER_EMAIL = "mail";
        LDAP_ATTRIBUTE_USER_FIRST_NAME = "givenName";
        LDAP_ATTRIBUTE_USER_LAST_NAME = "sn";
        LDAP_ATTRIBUTE_USER_DISPLAY_NAME = "cn";
        # LDAP_ATTRIBUTE_USER_PROFILE_PICTURE = "jpegPhoto";
        LDAP_ATTRIBUTE_GROUP_MEMBER = "member";
        LDAP_ATTRIBUTE_GROUP_UNIQUE_IDENTIFIER = "entryUUID";
        LDAP_ATTRIBUTE_GROUP_NAME = "cn";
        LDAP_ATTRIBUTE_ADMIN_GROUP = "sbuk_admins";
      };
      environmentFile = config.sops.secrets.pocket_id.path;
    };
  };
  systemd = {
    services.pocketIdBackup = {
      enable = true;
      description = "Backup pocket-id data";
      after = [
        "network-online.target"
        "pocket-id.service"
      ];
      wants = [
        "network-online.target"
        "pocket-id.service"
      ];
      serviceConfig = {
        Type = "exec";
        EnvironmentFile = config.sops.secrets."backups/pocket-id".path;
        ExecStart = pkgs.writeScript "pocket-id-backup" ''
          #!${pkgs.bash}/bin/bash
          BORG_PASSPHRASE="$BORG_PASSPHRASE_LOCAL" ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/pocket-id::$(date -Is)" /var/lib/pocket-id
        '';
      };
      wantedBy = [ "multi-user.target" ];
    };
    timers.pocketIdBackup = {
      enable = true;
      unitConfig = {
        Description = "Regularly backup pocket-id data";
        PartOf = [ "pocketIdBackup.service" ];
      };
      timerConfig = {
        OnCalendar = "*-*-* 00:00:00";
        Unite = "pocketIdBackup.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
