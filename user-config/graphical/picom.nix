_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    xsession.windowManager.i3.config.startup = [
      { command = "picom -b"; always = true;}
    ];
    services.picom = {
      enable = true;
      package = pkgs.picom-next;
      fade = true;
      vSync = true;
      inactiveOpacity = 0.8;
      opacityRules = [ "100:name *= 'i3lock'" ];
      shadow = true;
      shadowExclude = [
        "class_g = 'Rofi'"
      ];
      shadowOpacity = .30;
      backend = "glx";
      experimentalBackends = true;
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
        blur-background-exclude = [
          "window_type = 'dock'"
        ];
      };
    };
  };
}
