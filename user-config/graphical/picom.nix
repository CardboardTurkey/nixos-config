{
  home-manager.users.kiran = { pkgs, ... }: {
    services.picom = {
      enable = true;
      fade = true;
      vSync = true;
      inactiveOpacity = 0.8;
      opacityRules = [ "100:name *= 'i3lock'" ];
      shadow = true;
      shadowExclude = [ "class_g = 'Rofi'" ];
      shadowOpacity = 0.3;
      backend = "glx";
      settings = {
        blur = {
          method = "dual_kawase";
          strength = 8;
          background = false;
          background-frame = false;
          background-fixed = false;
        };
        focus-exclude = [
          "class_g = 'rofi'"
          "class_g = 'polybar'"
          "I3_FLOATING_WINDOW@:c"
          "fullscreen"
        ];
        # shadowOffset complains for some reason
        shadow-offset-x = -10;
        shadow-offset-y = -10;
        corner-radius = 15;
        rounded-corners-exclude = [ "class_g = 'i3-frame'" ];
        blur-background-exclude = [ "window_type = 'dock'" ];
      };
    };
  };
}
