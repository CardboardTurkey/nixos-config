{
  osConfig,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = false;
      preload = [ "${osConfig.wallpapers.single}" ];
      wallpaper = [
        ", ${osConfig.wallpapers.single}"
      ];
    };
  };
}
