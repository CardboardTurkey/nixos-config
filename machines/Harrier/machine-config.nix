{
  config,
  userModPaths,
  pkgs,
  ...
}:
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

  # Until bug gets fixed https://lore.kernel.org/linux-wireless/1263051271.53086.1674425560245.JavaMail.zimbra@nod.at/
  systemd.services = {
    ath11k-resume = {
      serviceConfig.Type = "oneshot";
      wantedBy = [
        "suspend.target"
        "suspend-then-hibernate.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];
      after = [
        "suspend.target"
        "suspend-then-hibernate.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];
      script = ''
        ${pkgs.kmod}/bin/modprobe ath11k_pci
      '';
    };

    ath11k-suspend = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
      script = ''
        ${pkgs.kmod}/bin/rmmod ath11k_pci
      '';
    };
  };

}
