{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "2h";
      matchBlocks = {
        "www1" = {
          hostname = "5.78.76.134";
          user = "kostrolenk";
        };
        "rpi" = {
          hostname = "100.64.201.123";
          user = "kiran";
        };
      };
    };
  };
}
