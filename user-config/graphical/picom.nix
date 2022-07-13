_:

{   
  home-manager.users.kiran = { pkgs, ... }: {
    services.picom = {
      enable = true;
      fade = true;
      vSync = true;
      inactiveOpacity = 0.8;
      opacityRules = [ "100:name *= 'i3lock'" ];
      backend = "glx";
      experimentalBackends = true;
      settings = {
        blur = {
          method = "dual_kawase";
          strength = 16;
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
      };
    };
  };
}
