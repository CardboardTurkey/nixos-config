{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.atuinAddress = lib.mkOption {
    default = "100.72.92.20";
    type = lib.types.str;
    description = "IP address for atuin server";
  };
  config.services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
    };
    atuin = {
      enable = true;
      openFirewall = true;
      openRegistration = true;
      host = config.atuinAddress;
      database = {
        createLocally = true;
        # uri = "postgresql://atuin@localhost:5432/atuin";
      };
    };
  };
}
