{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "2h";
    forwardAgent = true;
    matchBlocks = {
      "mgmt" = {
        hostname = "www1.mgmt.smoothbrained.co.uk";
        user = "kostrolenk";
      };
      "rpi" = {
        hostname = "100.64.201.123";
        user = "kiran";
      };
    };
  };
}
