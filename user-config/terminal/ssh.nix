{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "30m";
      matchBlocks = {
        "rpi" = {
          hostname = "100.64.201.123";
          user = "kiran";
        };
      };
    };
  };
}
