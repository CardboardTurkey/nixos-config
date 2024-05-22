{pkgs, ...}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  networking.firewall.enable = false;
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
