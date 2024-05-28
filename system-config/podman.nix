{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ podman ];
  virtualisation.podman.enable = true;
}
