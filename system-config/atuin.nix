{
  services.atuin = {
    enable = true;
    openFirewall = true;
    openRegistration = true;
    host = "172.16.1.2";
    database = {
      createLocally = true;
      # uri = "postgresql://atuin@localhost:5432/atuin";
    };
  };
}
