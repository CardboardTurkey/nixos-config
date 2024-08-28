{ lib, config, ... }: {
  imports = [
    # Include the necessary packages and configuration for Apple Silicon support.
    ./apple-silicon-support
    ../pc_common.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkForce true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  hardware.asahi = {
    withRust = true;
    useExperimentalGPUDriver = true;
  };

  ## FIRMWARE ##
  # Might not actually need this:
  # Specify path to peripheral firmware files.
  # hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  # Or disable extraction and management of them completely.
  # hardware.asahi.extractPeripheralFirmware = false;

  monitor_scale = 2;
  root = "f7b8da31-abcd-4352-87a0-e354ecc3b8e8";
  wlan = "wlan0";
  kestrel_host_age =
    "age15pdkyxtv9558tf23sm2pth2qrr0qt2cdwvhwa3shftgcwvvzgazsgenmp2";
  hostname = "Osprey";
  wallpapers = {
    png = "/home/kiran/Downloads/png-2702691.png";
    single = "/home/kiran/Pictures/Wallpapers/iceland_arch.jpg";
    dual = {
      left = "/home/kiran/Pictures/Wallpapers/Polar_Bear/left.jpg";
      right = "/home/kiran/Pictures/Wallpapers/Polar_Bear/right.jpg";
    };
  };

  # Extra user
  home-manager = {
    users = {
      choochoo = {
        home.stateVersion = "22.11";
        imports = [
          ../../user-config/graphical/codium.nix
          ../../user-config/graphical/gtk.nix
          ../../user-config/graphical/hyprland.nix
          ../../user-config/graphical/dunst.nix
          ../../user-config/graphical/cursor.nix
          ../../user-config/graphical/obs-studio.nix
          ../../user-config/graphical/rofi.nix
          ../../user-config/graphical/eww.nix
          ../../user-config/graphical/hyprlock.nix

          ../../user-config/terminal/git.nix
          ../../user-config/terminal/eza.nix
          ../../user-config/terminal/starship.nix
          ../../user-config/terminal/alacritty.nix
          ../../user-config/terminal/tmux.nix
          ../../user-config/terminal/zsh.nix
          ../../user-config/terminal/nushell.nix
          ../../user-config/terminal/neovim.nix
          ../../user-config/terminal/bat.nix
          ../../user-config/terminal/direnv.nix
          ../../user-config/terminal/ssh.nix
          ../../user-config/terminal/zoxide.nix
          ../../user-config/terminal/fzf.nix

          ../../user-config/other/fontconfig.nix
          ../../user-config/other/sops_config.nix
          ../../user-config/other/batsignal.nix
        ];
      };
    };
  };

  # luks
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/${config.root}";
      preLVM = true;
      allowDiscards = true;
    };
  };
}
