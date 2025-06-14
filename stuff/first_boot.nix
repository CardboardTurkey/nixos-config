{
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  environment.systemPackages = with pkgs; [
    git
    helix
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-partuuid/__PART_UUID__";
      preLVM = true;
      allowDiscards = true;
    };
  };

  system.stateVersion = "25.05";
}
