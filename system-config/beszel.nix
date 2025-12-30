{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ config.services.beszel.hub.port ];
  # For some reason user doesn't get created by default
  users = {
    groups = {
      beszel-hub = { };
      beszel-agent = { };
      # disk.members = [ "beszel-agent" ];
    };
    users =
      let
        mkUser = user: {
          isSystemUser = true;
          home = "/var/empty";
          group = "beszel-${user}";
          shell = pkgs.shadow; # This provides the /bin/nologin binary
          createHome = false;
          description = "Beszel ${user}";
        };
      in
      {
        beszel-hub = mkUser "hub";
        beszel-agent = mkUser "agent";
      };
  };
  sops.secrets = {
    "beszel/hub" = {
      owner = "beszel-hub";
      group = "beszel-hub";
    };
    "beszel/agent" = {
      # owner = "beszel-agent";
      # group = "beszel-agent";
    };
  };

  systemd.services.beszel-agent.serviceConfig = {
    User = lib.mkForce "root";
    DeviceAllow = [
      # NVIDIA GPU
      "/dev/nvidiactl rw"
      "/dev/nvidia0 rw"
      # Smart
      "/dev/sda r"
      "/dev/nvme0 r"
    ];
    AmbientCapabilities = [
      "CAP_SYS_RAWIO"
      "CAP_SYS_ADMIN"
    ];
    CapabilityBoundingSet = [
      "CAP_SYS_RAWIO"
      "CAP_SYS_ADMIN"
    ];
    ProtectKernelLogs = lib.mkForce "no";
    ProtectSystem = lib.mkForce "no";
    KeyringMode = lib.mkForce "inherit";
    LockPersonality = lib.mkForce "no";
    ProtectClock = lib.mkForce "no";
    ProtectHome = lib.mkForce "no";
    ProtectHostname = lib.mkForce "no";
    RemoveIPC = lib.mkForce "no";
    RestrictSUIDSGID = lib.mkForce "false";
  };
  services.beszel = {
    hub = {
      enable = true;
      host = config.sbukAddress;
      port = 35794;
      environment = {
        # Password defined in secrets file
        USER_EMAIL = "kostrolenk@smoothbrained.co.uk";
      };
      environmentFile = config.sops.secrets."beszel/hub".path;
    };
    agent = {
      enable = true;
      extraPath = with pkgs; [
        linuxPackages.nvidia_x11
        smartmontools
      ];
      environment = {
        HUB_URL = "http://${config.services.beszel.hub.host}:${builtins.toString config.services.beszel.hub.port}";
        SMART_DEVICES = "/dev/nvme0,/dev/sda";
        LOG_LEVEL = "debug";
      };
      environmentFile = config.sops.secrets."beszel/agent".path;
    };
  };
}
