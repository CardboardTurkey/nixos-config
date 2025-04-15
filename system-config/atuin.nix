{
  pkgs,
  config,
  ...
}:
{
  services = {
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
