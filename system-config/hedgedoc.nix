{ config, ... }:
let
  ipAddress = "172.16.100.3";
  port = 61967;
  domain = "pad.kiran.smoothbrained.co.uk";
in
{
  sops.secrets."hedgedoc" = {
    owner = "hedgedoc";
    group = "hedgedoc";
  };
  networking.firewall.allowedTCPPorts = [ port ];
  services.hedgedoc = {
    enable = true;
    settings = {
      loglevel = "debug";
      port = port;
      host = ipAddress;
      domain = domain;
      protocolUseSSL = true;
      email = false;
      allowEmailRegister = false;
      ldap = {
        url = "ldaps://ldap.smoothbrained.co.uk";
        bindDn = "cn=hedgedoc,ou=sysaccounts,dc=smoothbrained,dc=co,dc=uk";
        # bindCredentials = "$bindCredentials";
        searchBase = "ou=people,dc=smoothbrained,dc=co,dc=uk";
        searchFilter = "(uid={{username}})";
        useridField = "uid";
        providerName = "Smoothbrained 🧠";
      };
    };
  };
  systemd.services.hedgedoc.serviceConfig.EnvironmentFile = config.sops.secrets."hedgedoc".path;
}
