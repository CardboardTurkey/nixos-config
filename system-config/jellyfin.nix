{ config, pkgs, ... }:
{
  sops.secrets = {
    "domains/ostrolenk/id" = {
      owner = "acme";
      group = "acme";
    };
    "domains/ostrolenk/secret" = {
      owner = "acme";
      group = "acme";
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "kiran@ostrolenk.co.uk";
      group = config.services.nginx.group;
    };
    certs."watch.ostrolenk.co.uk" = {
      dnsProvider = "mythicbeasts";
      environmentFile = "${pkgs.writeText "mythbea-creds" ''
        MYTHICBEASTS_USERNAME_FILE=${config.sops.secrets."domains/ostrolenk/id".path}
        MYTHICBEASTS_PASSWORD_FILE=${config.sops.secrets."domains/ostrolenk/secret".path}
      ''}";
    };
  };
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts."watch.ostrolenk.co.uk" = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/watch.ostrolenk.co.uk/cert.pem";
        sslCertificateKey = "/var/lib/acme/watch.ostrolenk.co.uk/key.pem";
        locations."/" = {
          proxyPass = "http://localhost:8096";
        };
      };
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "kiran";
      group = "kiran";
    };
  };
  systemd.services.jellyfin.environment = config.nvidiaOffload;
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
