# Create backup:
# 1. `sudo borg init -e repokey /backup/shell` (using password from secrets file)
# 2. `sudo chown -R postgres /backup/shell`
#
# Restore from backup with `sudo -u postgres pg_restore --clean -d atuin --host=/run/postgresql < /tmp/atuin.dump`
#
# Afterwards you might need to re-encrypt:
# `atuin store purge` - this will delete all records in the store that cannot be decrypted with the current key
# `atuin store verify` - verify that the previous operation was successful
# `atuin store push --force` - this will delete all records stored remotely, and then push up local data. Run this on the machine that has been purged
# `atuin store pull --force` - this does the opposite to (3). Delete all local data in the store, and pull from the remote
# `atuin store rebuild history` - ensure your history.db is up to date after all these operations

{
  imports = [ ./data.nix ];
  sops.secrets."backups/postgres" = {
    owner = "postgres";
    group = "postgres";
  };
  services = {
    atuin = {
      enable = true;
      openFirewall = true;
      openRegistration = true;
      host = "0.0.0.0";
      database.createLocally = true;
    };
  };
}
