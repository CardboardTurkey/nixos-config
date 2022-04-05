{ config, lib, pkgs, ... }:

{   
  home-manager.users.kiran = { pkgs, ... }: {
    services.picom = {
      enable = true;
      blur = true;
      fade = true;
      vSync = true;
      inactiveOpacity = "0.8";
      opacityRule = [ "100:name *= 'i3lock'" ];
      blurExclude = [ "class_g = 'Dunst'" ];
      experimentalBackends = true;
      extraOptions = ''
        focus-exclude = [ 
          "class_g = 'rofi'",
          "class_g = 'polybar'",
          "I3_FLOATING_WINDOW@:c",
          "fullscreen",
        ];
        blur-method = "dual_kawase";
        blur-strength = 16;
      '';
    };
  };
}