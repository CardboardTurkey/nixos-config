{ pkgs, config, ... }:

{

  imports = [
    ./sops.nix
    ../../system-config/docker.nix
  ];

  # https://stackoverflow.com/questions/413807/is-there-a-way-for-non-root-processes-to-bind-to-privileged-ports-on-linux
  # https://www.staldal.nu/tech/2007/10/31/why-can-only-root-listen-to-ports-below-1024/
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [
      7421
      7422
    ];
  };

  virtualisation.docker.logDriver = "journald";

  # `loginctl enable-linger username` for start at boot.
  systemd.user.services.webserver = {
    enable = true;
    wantedBy = [ "default.target" ];
    path = [
      pkgs.docker-compose
      pkgs.docker
    ];
    requires = [ "docker.service" ];
    partOf = [ "renew-cert.service" ];
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
    path = [
      pkgs.docker-compose
      pkgs.docker
    ];
    requires = [
      "webserver.service"
      "docker.service"
    ];
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

  systemd.user.services.update_nginx = {
    enable = true;
    path = [ pkgs.docker ];
    script = "DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock docker pull nginx:latest";
  };
  systemd.user.timers.update_nginx = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "Sat *-*-* 04:00:00" ];
  };

  systemd.services.fixall = {
    enable = true;
    script = "echo incoming";
    onSuccess = [ "reboot.target" ];
  };
  systemd.timers.fixall = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "Sun *-*-* 04:00:00" ];
  };

  sops.secrets."domains/ostrolenk/username" = { };
  sops.secrets."domains/ostrolenk/password" = { };
  sops.secrets."domains/kiran/username" = { };
  sops.secrets."domains/kiran/password" = { };
  sops.secrets."domains/www/username" = { };
  sops.secrets."domains/www/password" = { };

  systemd.services.dyndns = {
    enable = true;
    path = [ pkgs.curl ];
    script = ''
      function update_ip {
        # Resolve current public IP
        IP=$( curl -s -k https://domains.google.com/checkip )
        # Update Google DNS Record
        URL="https://$1:$2@domains.google.com/nic/update?hostname=$3&myip=''${IP}"
        curl -s $URL
      }

      USERNAME=$(cat ${toString config.sops.secrets."domains/ostrolenk/username".path})
      PASSWORD=$(cat ${toString config.sops.secrets."domains/ostrolenk/password".path})
      HOSTNAME="ostrolenk.co.uk"
      update_ip $USERNAME $PASSWORD $HOSTNAME

      USERNAME=$(cat ${toString config.sops.secrets."domains/kiran/username".path})
      PASSWORD=$(cat ${toString config.sops.secrets."domains/kiran/password".path})
      HOSTNAME="kiran.ostrolenk.co.uk"
      update_ip $USERNAME $PASSWORD $HOSTNAME

      USERNAME=$(cat ${toString config.sops.secrets."domains/www/username".path})
      PASSWORD=$(cat ${toString config.sops.secrets."domains/www/password".path})
      HOSTNAME="www.ostrolenk.co.uk"
      update_ip $USERNAME $PASSWORD $HOSTNAME
    '';
  };
  systemd.timers.dyndns = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "*-*-* *:*:00" ];
  };

}
