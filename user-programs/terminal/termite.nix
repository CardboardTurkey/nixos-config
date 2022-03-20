{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.termite = {
      enable = true;
      enableVteIntegration = true;
      allowBold = true;
      backgroundColor = "${config.nord0}";
      colorsExtra = ''
        color0  = ${config.nord1}
        color1  = ${config.nord11}
        color2  = ${config.nord14}
        color3  = ${config.nord13}
        color4  = ${config.nord9}
        color5  = ${config.nord15}
        color6  = ${config.nord8}
        color7  = ${config.nord5}
        color8  = ${config.nord3}
        color9  = ${config.nord11}
        color10 = ${config.nord14}
        color11 = ${config.nord13}
        color12 = ${config.nord9}
        color13 = ${config.nord15}
        color14 = ${config.nord7}
        color15 = ${config.nord6}
      '';
      cursorColor = "${config.nord4}";
      cursorForegroundColor = "${config.nord0}";
      foregroundColor = "${config.nord4}";
      foregroundBoldColor = "${config.nord4}";
      font = "DejaVuSansMono Nerd Font Mono 20";
    };
  };
}