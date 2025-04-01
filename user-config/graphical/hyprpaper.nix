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
      preload = [ "${osConfig.pics.wallpaper}" ];
      wallpaper = [
        ", ${osConfig.pics.wallpaper}"
      ];
    };
  };
}
