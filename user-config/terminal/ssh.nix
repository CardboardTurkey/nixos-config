{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "2h";
    forwardAgent = true;
    matchBlocks = {
      "fw1" = {
        hostname = "fw1.core.smoothbrained.co.uk";
        user = "local-kostrolenk";
      };
      "fw1.mgmt.smoothbrained.co.uk" = {
        hostname = "fw1.core.smoothbrained.co.uk";
        user = "local-kostrolenk";
      };
      "www2" = {
        hostname = "www2.mgmt.smoothbrained.co.uk";
        user = "local-kostrolenk";
      };
      "www2.mgmt.smoothbrained.co.uk" = {
        hostname = "www2.mgmt.smoothbrained.co.uk";
        user = "local-kostrolenk";
      };
      "rpi" = {
        hostname = "100.64.201.123";
        user = "kiran";
      };
    };
  };
}
