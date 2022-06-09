_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.bat = {
      enable = true;
      config = { theme = "Nord"; };
    };
  };
}
