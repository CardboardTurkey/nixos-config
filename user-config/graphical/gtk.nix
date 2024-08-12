{
  home-manager.users.kiran = { pkgs, osConfig, ... }: {
    # home.packages = [ pkgs.atool pkgs.httpie ];
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.zafiro-icons;
        name = "Zafiro-icons-Dark";
      };
      font = {
        name =
          "Bitstream Vera Sans ${builtins.toString osConfig.font_size_small}";
      };
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
    };
  };
}
