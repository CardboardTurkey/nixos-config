{pkgs, ...}:
{
  services.jellyfin = {
    enable = false;
    openFirewall = true;
  };
  networking.firewall.enable = false;
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
