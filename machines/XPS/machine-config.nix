{ lib, pkgs, ... }:

let
  patchDesktop = pkg: appName: from: to:
    lib.hiPrio (pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
      ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
      ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
    '');

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in {

  imports = [
    ../pc_common.nix
    ../../system-config/sops.nix
  ];

  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

  root = "172c2b88-8909-441b-b441-6ea20cd54450";
  hostname = "Kestrel";
  allowed_unfree = [
    "steam"
    "steam-original"
    "steam-runtime"
    "steam-run"
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

      cursor = { no_hardware_cursors = true; };
    };
    services.hypridle.settings.listener = [{
      timeout = 150; # 2.5min.
      on-timeout =
        "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
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
    # (patchDesktop steam "steam" "^Exec=" "&nvidia-offload ")
    # nvidia-offload
    discord
    libva
    xorg.xrandr
  ];

  # ------
  # NVIDIA
  # ------

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia.open = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs;
        [
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

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/2de02d4e-f542-495d-9123-6180ab1acb21";
      preLVM = true;
      allowDiscards = true;
    };
  };

}
