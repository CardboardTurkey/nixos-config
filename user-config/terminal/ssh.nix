{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        controlPersist = "yes";
        controlMaster = "auto";
        controlPath = "~/.ssh/controlmasters/%r@%h:%p";
        forwardAgent = true;
        addKeysToAgent = "yes";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
      };
      "fw1" = {
        hostname = "fw1.core.smoothbrained.co.uk";
        user = "local-kostrolenk";
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
    };
  };
}
