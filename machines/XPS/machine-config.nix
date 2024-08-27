{ lib, pkgs, ... }:
with pkgs;

let
  patchDesktop = pkg: appName: from: to:
    lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" { } ''
      ${coreutils}/bin/mkdir -p $out/share/applications
      ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
    '');

  nvidia-offload = writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in {

  imports = [
    ../pc_common.nix
    ../../system-config/ayden_vpn.nix
    ../../system-config/sops.nix
    ../../system-config/sbuk.nix
  ];

  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" "sd_mod" ];

  wlan = "wlp59s0";
  battery = "BAT0";
  edp1 =
    "00ffffffffffff004d10ba1400000000161d0104a52213780ede50a3544c99260f505400000001010101010101010101010101010101ac3780a070383e403020350058c210000018000000000000000000000000000000000000000000fe004d57503154804c513135364d31000000000002410332001200000a010a202000d3";
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
  wallpapers = {
    png = "/home/kiran/Downloads/png-2702691.png";
    single = builtins.fetchurl "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/gnu-linux.png";
    dual = {
      left = "/home/kiran/Pictures/Wallpapers/Polar_Bear/left.jpg";
      right = "/home/kiran/Pictures/Wallpapers/Polar_Bear/right.jpg";
    };
  };

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
    services.hypridle.settings.listener = [
      {
        timeout = 150; # 2.5min.
        on-timeout =
          "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = "brightnessctl -r"; # monitor backlight restore.
      }
      {
        timeout = 300; # 5min
        on-timeout = "systemctl suspend"; # suspend pc
      }
    ];
  };

  # ------
  # Steam
  # ------

  programs.steam.enable = true;
  environment.systemPackages = [
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
  hardware.graphics = {
    enable = true;
    extraPackages = [
      nvidia-vaapi-driver
      # intel-media-driver
      # vaapiIntel
      # vaapiVdpau
      # libvdpau-va-gl
    ];
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
