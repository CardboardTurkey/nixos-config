{config, ...}:

{
  # Needed by gtk?
  programs.dconf.enable = true;
  
  home-manager.users.kiran = { pkgs, ... }: {
    # home.packages = [ pkgs.atool pkgs.httpie ];
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.zafiro-icons;
        name = "Zafiro-icons-Dark";
      };
      font = {
        name = "DejaVu Sans ${config.font_size_small}";
      };
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
    };
  };
}