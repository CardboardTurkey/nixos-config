let
  ipAddress = "172.16.100.3";
  port = 61967;
  domain = "pad.kiran.smoothbrained.co.uk";
in
{
  networking.firewall.allowedTCPPorts = [ port ];
  services.hedgedoc = {
    enable = true;
    settings = {
      port = port;
      host = ipAddress;
      domain = domain;
      # protocolUseSSL = true;
    };
  };
  # services.nginx = {
  #   enable = true;
  #   virtualHosts."${domain}" = {
  #     locations."/" = {
  #       proxyPass = "http://${ipAddress}:${builtins.toString port}";
  #       recommendedProxySettings = true;
  #       proxyWebsockets = true;
  # };
  # locations."/socket.io/" = {
  #   proxyPass = "http://127.0.0.1:${port}";
  #   proxyWebsockets = true;
  # };
  # };
  # };
}
