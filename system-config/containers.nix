{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker-compose
    nerdctl
  ];

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      rootless = {
        enable = true;
        setSocketVariable = true;
        # resolved has two different dns configs: https://unix.stackexchange.com/a/612434
        # For some reason rootless docker picks up the wrong one,
        # so lets just use cloudflare for now.
        daemon.settings.dns = [ "1.1.1.1" ];
      };
      daemon.settings.bip = "172.26.0.1/16";
    };
    containerd.enable = true;
  };
}
