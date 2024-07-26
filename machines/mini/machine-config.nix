{ lib, ... }: {
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

  wlan = "wlan0";
  kestrel_host_age =
    "age15pdkyxtv9558tf23sm2pth2qrr0qt2cdwvhwa3shftgcwvvzgazsgenmp2";
  hostname = "Osprey";
  wallpapers = {
    png = "/home/kiran/Downloads/png-2702691.png";
    single = "/home/kiran/Pictures/Wallpapers/flying_marsh_harrier.jpg";
    dual = {
      left = "/home/kiran/Pictures/Wallpapers/Polar_Bear/left.jpg";
      right = "/home/kiran/Pictures/Wallpapers/Polar_Bear/right.jpg";
    };
  };
}
