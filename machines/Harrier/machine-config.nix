{ config, userModPaths, ... }:
{
  imports = [
    ../pc_common.nix
    ../../system-config/sops.nix
  ];

  hostname = "Harrier";

  # Extra user
  home-manager = {
    users = {
      choochoo = {
        home.stateVersion = "22.11";
        imports = userModPaths config.userModules;
      };
    };
  };

  boot = {
    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-partuuid/7a8eb4e4-b15e-4341-9271-5948c5ca3bc0";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };

}
