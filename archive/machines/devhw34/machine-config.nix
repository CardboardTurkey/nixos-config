{ pkgs, ... }:

{

  imports = [ ../pc_common.nix ];

  email = "kiran.ostrolenk@codethink.co.uk";
  eth = "eno1";
  root = "5f3d43dc-1955-4eae-955a-1d151d08fcfc";
  dual_monitor_left = [ "DP-1" ];
  dual_monitor_right = [ "DP-2" ];
  hostname = "devhw34";
  home-manager.users.kiran = {
    programs.zsh.dirHashes = {
      lorry = "$HOME/git/CodethinkLabs/lorry/lorry2/";
      sm = "$HOME/ct-gitlab/sif/process/safety-monitor/";
    };
    programs.ssh = {
      includes = [
        "/home/kiran/git/cardboardturkey/nixos-config/user-config/files/vagrant_ssh"
      ];
    };
  };
  wallpapers = {
    single = "/home/kiran/Pictures/Wallpapers/ice_breaker.jpg";
    dual = {
      left = "/home/kiran/Pictures/Wallpapers/Polar_Bear/left.jpg";
      right = "/home/kiran/Pictures/Wallpapers/Polar_Bear/right.jpg";
    };
  };

  # Project change
  boot.kernel.sysctl = { "kernel.perf_event_paranoid" = 0; };

  powerManagement.cpuFreqGovernor = "performance";

  # # https://stackoverflow.com/questions/413807/is-there-a-way-for-non-root-processes-to-bind-to-privileged-ports-on-linux
  # # https://www.staldal.nu/tech/2007/10/31/why-can-only-root-listen-to-ports-below-1024/
  # boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  # # grafana configuration
  # services.grafana = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       # Listening Address
  #       http_addr = "10.35.5.148";
  #       # and Port
  #       http_port = 2342;
  #       # Grafana needs to know on which domain and URL it's running
  #       domain = "devhw34.office.codethink.co.uk";
  #       root_url = "http://devhw34.office.codethink.co.uk/grafana/";
  #     };
  #   };
  # };

  # services.prometheus = {
  #   enable = true;
  #   port = 9001;
  #   exporters = {
  #     node = {
  #       enable = true;
  #       enabledCollectors = [ "systemd" ];
  #       port = 9002;
  #     };
  #   };
  #   scrapeConfigs = [
  #     {
  #       job_name = "devhw34";
  #       static_configs = [{
  #         targets = [ "devhw34.office.codethink.co.uk:${toString config.services.prometheus.exporters.node.port}" ];
  #       }];
  #     }
  #   ];
  # };

  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # services.nginx.enable = true;
  # services.nginx.virtualHosts."devhw34.office.codethink.co.uk" = {
  #   # addSSL = true;
  #   # enableACME = true;
  #   locations."/grafana/" = {
  #     proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
  #     proxyWebsockets = true;
  #     recommendedProxySettings = true;
  #   };
  # };
  users.users.codething = {
    isNormalUser = true;
    home = "/home/codething";
    description = "Code Thing";
    shell = pkgs.bash;
    extraGroups =
      [ "codething" "docker" "wheel" ]; # Enable ‘sudo’ for the user.
  };
  users.groups.codething = { };
  users.users.kiran.extraGroups = [ "docker" "libvirtd" ];
  environment.systemPackages = with pkgs; [ tmux ];

  virtualisation.libvirtd.enable = true;
  networking.hosts = { "192.168.121.44" = [ "kiran.dev.codethink.co.uk" ]; };

}
