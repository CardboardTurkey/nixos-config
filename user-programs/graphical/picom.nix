{ config, lib, pkgs, ... }:

{   
  home-manager.users.kiran = { pkgs, ... }: {
    services.picom = {
      enable = true;
      blur = true;
      fade = true;
      inactiveOpacity = "0.8";
      opacityRule = [ "100:name *= 'i3lock'" ];
      experimentalBackends = true;
      extraOptions = ''
        vsync = true;
        focus-exclude = [ 
          "class_g = 'rofi'",
          "I3_FLOATING_WINDOW@:c",
          "fullscreen",
        ];
        blur-method = "dual_kawase";
        blur-strength = 16;
      '';
    };
  };
}