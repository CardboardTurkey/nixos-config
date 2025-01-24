{ pkgs, ... }:
{

  imports = [
    ../pc_common.nix
    ../../system-config/sops.nix
  ];

  hostname = "Harrier";
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-partuuid/7a8eb4e4-b15e-4341-9271-5948c5ca3bc0";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };

}
