{ pkgs, config, ... }:

{

  imports = 
    [
      ./src.nix
      ../../system-config/docker.nix
    ];

  # https://stackoverflow.com/questions/413807/is-there-a-way-for-non-root-processes-to-bind-to-privileged-ports-on-linux
  # https://www.staldal.nu/tech/2007/10/31/why-can-only-root-listen-to-ports-below-1024/
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
  
  networking.firewall = {
    allowedTCPPorts = [ 80 443 6342 ];
  };

  virtualisation.docker.logDriver = "journald";

  # `loginctl enable-linger username` for start at boot.
  systemd.user.services.webserver = {
    enable = true;
    wantedBy = [ "default.target" ];
    path = [ pkgs.docker-compose pkgs.docker ];
    requires = [ "docker.service" ];
    # Would be nice if this worked but I guess the var is defined at user level
    # environment =  { DOCKER_HOST = "unix://${builtins.getEnv "XDG_RUNTIME_DIR"}/docker.sock"; };
    serviceConfig = {
      WorkingDirectory = "${config.web_dir}";
    };
    script = "DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock docker compose up";
    reload = "DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock docker compose restart";
    preStop = "DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock docker compose stop";
  };

  systemd.user.services.renew-cert = {
    enable = true;
    after = [ "webserver.service" ];
    path = [ pkgs.docker-compose pkgs.docker ];
    requires = [ "webserver.service" "docker.service" ];
    serviceConfig = {
      WorkingDirectory = "${config.web_dir}";
    };
    script = "DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock docker compose run --rm certbot renew";
  };
  systemd.user.timers.renew-cert = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "monthly" ];
  };
}
