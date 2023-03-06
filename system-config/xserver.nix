{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeter.enable = true;
      };
    };
    desktopManager = {
      wallpaper = {
        mode = "fill";
      };
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };
}
