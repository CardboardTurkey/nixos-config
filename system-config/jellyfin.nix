{
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "kiran";
      group = "kiran";
    };
    caddy = {
      enable = true;
      email = "kiran@ostrolenk.co.uk";
      extraConfig = ''
        watch.ostrolenk.co.uk {
          bind 100.92.39.50
          reverse_proxy tcp4/100.92.39.50:8096 {
              # Pass the original Host header from the client to Jellyfin.
              # This is important for Jellyfin to generate correct URLs.
              header_up Host {host}
          }
        }
      '';
    };
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
