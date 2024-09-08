{ pkgs, osConfig, ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Bitstream Vera Sans ${
            builtins.toString
            (osConfig.monitor_scale * osConfig.font_size_large)
          }px";
        follow = "keyboard";
        frame_width = 1;
        width = "(0, 500)";
        offset = "22x69";
        min_icon_size = 16;
        max_icon_size = 48;
        # enable_recursive_icon_lookup = true;
        icon_theme = "Zafiro-icons-Dark";
        icon_path =
          "${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/actions:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/actions/16:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/actions/16-Dark:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/actions/22:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/actions/22-Dark:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/actions/48:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/apps:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/apps/16:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/apps/22:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/apps/48:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/apps/48-light:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/apps/scalable:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/categories:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/categories/22:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/categories/22-Dark:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/devices:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/devices/22:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/devices/48:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/emblems:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/emblems/16:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/emotes:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/mimetypes:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/mimetypes/48:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/panel:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/panel/16:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/panel/16-light:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/panel/22:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/panel/22-light:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places/16:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places/16-A:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places/22:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places/24:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places/48:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places/48-black-red:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/places/48-blue:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/previews:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/status:${pkgs.zafiro-icons}/share/icons/Zafiro-icons-Dark/status/22/";
        progress_bar_height = 30;
        idle_threshold = 9;
        padding = 25;
        horizontal_padding = 25;
        corner_radius = 15;
      };
      urgency_low.timeout = 10;
      urgency_normal.timeout = 10;
      urgency_critical.timeout = 0;
    };
  };
}
