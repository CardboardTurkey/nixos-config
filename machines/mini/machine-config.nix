{
  lib,
  config,
  userModPaths,
  ...
}:
{
  imports = [ ../pc_common.nix ];

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
  kestrel_host_age = "age15pdkyxtv9558tf23sm2pth2qrr0qt2cdwvhwa3shftgcwvvzgazsgenmp2";
  hostname = "Osprey";

  # Extra user
  home-manager = {
    users = {
      choochoo = {
        home.stateVersion = "22.11";
        imports = userModPaths config.userModules;
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

  users.users.kiran.openssh.authorizedKeys.keys = [ "${config.pgp_auth_2_ssh}" ];

  # services.datadog-agent = {
  #   enable = true;
  #   enableLiveProcessCollection = true;
  #   enableTraceAgent = true;
  #   apiKeyFile = "/var/log/datadog/ddagent.key";
  #   extraConfig = {
  #     logs_enabled = true;
  #     GUI_port = 5112;
  #   };
  # };
}
