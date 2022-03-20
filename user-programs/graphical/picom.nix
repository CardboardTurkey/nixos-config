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
        blur:
        {
        method="dual_kawase";
        strength=5;
        }
      '';
    };
  };
}