{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  home-manager.users.kiran = {
    programs.zsh = {
      envExtra = "export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock";
    };
    programs.nushell = {
      extraEnv = "$env.DOCKER_HOST = $'unix://($env.XDG_RUNTIME_DIR)/docker.sock'";
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    rootless = {
      enable = true;
    };
  };
}
