_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.ssh.matchBlocks = {
      "rpi" = {
        hostname = "100.64.201.123";
        name = "kiran";
      };
    };
  };
}
