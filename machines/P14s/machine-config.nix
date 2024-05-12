{ pkgs, config, ... }:
{

  imports =
    [
      ../pc_common.nix
      ../../user-config/other/sops.nix
      ../../system-config/ayden_vpn.nix
      ../../system-config/sbuk.nix
      ../../system-config/flatpack.nix
    ];

  swapDevices = [ { device = "/dev/dm-1"; } ];

  # For touch-to-click
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  boot.plymouth = {
    enable = true;
    theme = "colorful_loop";
    themePackages = [ pkgs.local.colorful_loop ];
  };

  email = "kiran.ostrolenk@codethink.co.uk";
  eth = "enp0s31f6";
  wlan = "wlp0s20f3";
  battery = "BAT0";
  adapter = "AC";
  root = "1193f3f4-4289-42f4-ac35-67343dafc1e0";
  dual_monitor_left = [ "DP-6" ];
  dual_monitor_right = [ "DP-7" ];
  hostname = "Harrier";
  sops.secrets."gitconfig/url1" = {
    mode = "0440";
    owner = config.users.users.kiran.name;
    group = config.users.users.kiran.group;
  };
  sops.secrets."work_ssh" = {
    mode = "0440";
    owner = config.users.users.kiran.name;
    group = config.users.users.kiran.group;
  };
  home-manager.users.kiran = {
    # Project change
    programs.git = {
      extraConfig.credential.helper = "store";
      includes = [{
        path = config.sops.secrets."gitconfig/url1".path;
      }];
    };
    # Project change
    programs.ssh = {
      includes = [ "${toString config.sops.secrets."work_ssh".path}" ];
      matchBlocks = {
        "fs" = {
          hostname = "fs.office.codethink.co.uk";
          user = "kiran";
        };
      };
    };
    programs.zsh.dirHashes = {
      lorry = "$HOME/git/CodethinkLabs/lorry/lorry2/";
      sm = "$HOME/ct-gitlab/sif/process/safety-monitor/";
    };
  };
  # Project change
  users.users.kiran.extraGroups = [ "dialout" "docker" ];
  wallpapers = {
    single = "/home/kiran/Pictures/Wallpapers/ice_breaker.jpg";
    dual = {
      left = "/home/kiran/Pictures/Wallpapers/Polar_Bear/left.jpg";
      right = "/home/kiran/Pictures/Wallpapers/Polar_Bear/right.jpg";
    };
  };

  # Project change
  boot.kernel.sysctl = { "kernel.perf_event_paranoid" = 0; };

  # powerManagement.cpuFreqGovernor = "performance";

  # Need fs.office.codethink.co.uk entry added to /root/.ssh/known_hosts
  # and a key without passphrase. This isn't a security issue as you need
  # to be on the office network to access fs anyway.
  environment.systemPackages = [ pkgs.sshfs ];
  # user@host:/remote/path /local/path  fuse.sshfs noauto,x-systemd.automount,_netdev,users,idmap=user,IdentityFile=/home/user/.ssh/id_rsa,allow_other,reconnect 0 0
  fileSystems."/fs" =
    {
      device = "kiranostrolenk@fs.office.codethink.co.uk:/home/users/kiranostrolenk/public_html";
      fsType = "fuse.sshfs";
      noCheck = true;
      options = [
        "noauto"
        "x-systemd.automount"
        "_netdev"
        "users"
        "idmap=user"
        "IdentityFile=/home/kiran/.ssh/id_ed25519_fs"
        "allow_other"
        "reconnect"
        "debug"
      ];
    };

  # ------
  # NVIDIA
  # ------

  allowed_unfree = [
    "nvidia-x11"
    "nvidia-settings"
  ];

  home-manager.users.kiran.wayland.windowManager.hyprland.extraConfig = ''
    # Some default env vars.
    env = XCURSOR_SIZE,24
    env = LIBVA_DRIVER_NAME,nvidia
    env = XDG_SESSION_TYPE,wayland
    # env = GBM_BACKEND,nvidia-drm
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = WLR_NO_HARDWARE_CURSORS,1
  '';

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    extraPackages = [
      pkgs.nvidia-vaapi-driver
      # intel-media-driver
      # vaapiIntel
      # vaapiVdpau
      # libvdpau-va-gl
    ];
  };

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

}
