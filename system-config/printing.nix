{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ system-config-printer ];
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
