{ pkgs, ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      widgets = [
        "inhibitors"
        "title"
        "dnd"
        "notifications"
        "mpris"
        "volume"
      ];
    };
  };
  wayland.windowManager.hyprland.settings.bind = [
    "MOD3, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t"
  ];
}
