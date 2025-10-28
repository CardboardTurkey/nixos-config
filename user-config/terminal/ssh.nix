{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      # "*" = {
      #   controlPersist = "2h";
      #   controlMaster = "auto";
      #   forwardAgent = true;
      # };
      "fw1" = {
        hostname = "fw1.core.smoothbrained.co.uk";
        user = "local-kostrolenk";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        controlPersist = "2h";
        controlMaster = "auto";
        forwardAgent = true;
      };
      "fw1.core.smoothbrained.co.uk" = {
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
