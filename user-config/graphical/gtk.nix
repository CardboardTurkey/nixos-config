{ pkgs, osConfig, ... }: {
  # home.packages = [ pkgs.atool pkgs.httpie ];
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.zafiro-icons;
      name = "Zafiro-icons-Dark";
    };
    theme = {
      name = "Dracula";
      package =
        pkgs.dracula-theme; # catppuccin gtk port is deprecated, so this will do for now
    };
    font = {
      name =
        "Bitstream Vera Sans ${builtins.toString osConfig.font_size_small}";
    };
  };
}
