{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ system-config-printer ];
  services.printing.enable = true;
}
