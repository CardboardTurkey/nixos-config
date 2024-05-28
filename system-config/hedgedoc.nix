{
  networking.firewall.allowedTCPPorts = [ 3000 ];
  services.hedgedoc = {
    enable = true;
    settings = {
      port = 3000;
      host = "127.0.0.1";
      domain = "pad.smoothbrained.co.uk";
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts."pad.smoothbrained.co.uk" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
      locations."/socket.io/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
  };
  networking.hosts = { "127.0.0.1" = [ "pad.smoothbrained.co.uk" ]; };
}
