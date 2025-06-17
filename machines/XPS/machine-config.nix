{
  lib,
  pkgs,
  config,
  ...
}:

let
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

in
{

  imports = [
    ../pc_common.nix
    ../../system-config/sops.nix
  ];

  users.users.kiran.openssh.authorizedKeys.keys = [
    "${config.pgp_auth_2_ssh}"
    "${config.pgp_auth_ssh}"
  ];

  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  root = "172c2b88-8909-441b-b441-6ea20cd54450";
  hostname = "Kestrel";
  allowed_unfree = [
    "steam"
    "steam-original"
    "steam-runtime"
    "steam-run"
    "steam-unwrapped"
    "nvidia-x11"
    "nvidia-settings"
    "discord"
    "prismlauncher"
  ];

  home-manager.users.kiran = {
    wayland.windowManager.hyprland.settings = {
      env = [
        # nvidia stuff
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        # Firefox seems to hate this
        # "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"

      ];

      cursor = {
        no_hardware_cursors = true;
      };
    };
    services.hypridle.settings.listener = [
      {
        timeout = 150; # 2.5min.
        on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = "brightnessctl -r"; # monitor backlight restore.
      }
      # {
      #   timeout = 300; # 5min
      #   on-timeout = "systemctl suspend"; # suspend pc
      # }
    ];
  };

  # ------
  # Steam
  # ------

  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    prismlauncher
    steam
    (patchDesktop steam "steam" "^Exec=" "&nvidia-offload ")
    nvidia-offload
    discord
    libva
    xorg.xrandr
  ];

  # ------
  # NVIDIA
  # ------

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false; # DOESNT SEEM TO WORK ON XPS

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently "beta quality", so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      prime = {
        offload.enable = true;

        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:0:2:0";

        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        # intel-media-driver
        # vaapiIntel
        # vaapiVdpau
        # libvdpau-va-gl
      ];
    };
  };

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  boot.initrd.luks = {
    # Would like to reuse passphrase but nix complains:
    #   Failed assertions:
    #     - boot.initrd.luks.reusePassphrases has no effect with systemd stage 1.
    # reusePassphrases = true;
    devices = {
      crypted = {
        device = "/dev/disk/by-partuuid/72c5fd60-a3d6-4a10-8832-3ca610a8d984";
        preLVM = true;
        allowDiscards = true;
      };
      backup = {
        device = "/dev/disk/by-partuuid/3344f210-67d7-46dd-a3a7-b8fdeb1a76ae";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };
  fileSystems."/backup".device = "/dev/mapper/backup";

  services.logind.lidSwitchExternalPower = "ignore";
}
