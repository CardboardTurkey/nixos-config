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
    "backups/media" = { };
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
  systemd = {
    services = {
      jellyfin.environment = config.nvidiaOffload;
      mediaBackup = {
        enable = true;
        description = "Backup media data";
        after = [
          "network-online.target"
          "jellyfin.service"
        ];
        wants = [
          "network-online.target"
          "jellyfin.service"
        ];
        serviceConfig = {
          Type = "exec";
          EnvironmentFile = config.sops.secrets."backups/media".path;
          ExecStart = pkgs.writeScript "media-backup" ''
            #!${pkgs.bash}/bin/bash
            ${pkgs.borgbackup}/bin/borg create -v --stats --progress --show-rc --compression lz4 --exclude-caches "/backup/media::$(date -Is)" /var/lib/jellyfin /home/kiran/Media/TV /home/kiran/Media/Movies
          '';
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
    timers = {
      mediaBackup = {
        enable = true;
        unitConfig = {
          Description = "Regularly backup media data";
          PartOf = [ "mediaBackup.service" ];
        };
        timerConfig = {
          OnCalendar = "*-*-* 00:00:00";
          Unite = "mediaBackup.service";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
