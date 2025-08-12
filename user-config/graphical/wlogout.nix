{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  # Having GTK issues on asahi linux
  pkg = with pkgs; if (osConfig.hostname == "Osprey") then wlogout else wleave;
in
{
  programs.wlogout = {
    enable = true;
    package = pkg;
    layout =
      let
        hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
        systemctl = lib.getExe' pkgs.systemd "systemctl";
        # Combining low line character to underline text based on keybind.
        underline = builtins.fromJSON ''"\u0332"'';
      in
      [
        {
          label = "logout";
          action = "${hyprctl} dispatch exit";
          text = "E${underline}xit";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "${systemctl} poweroff";
          text = "Shu${underline}tdown";
          keybind = "u";
        }
        {
          label = "suspend";
          action = "${systemctl} suspend";
          text = "S${underline}uspend";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "${systemctl} reboot";
          text = "R${underline}eboot";
          keybind = "r";
        }
      ];
  };

  # catppuccin.wlogout =
  #   let
  #     inherit (config.catppuccin.wlogout) flavor;
  #     palette = lib.importJSON "${config.catppuccin.sources.palette}/palette.json";
  #     mantle = palette.${flavor}.colors.mantle.hex;
  #     surface0 = palette.${flavor}.colors.surface0.hex;
  #   in
  #   {
  #     iconStyle = pkg.pname;
  #     extraStyle = ''
  #       * {
  #         font-family: "${config.home.fonts.sansSerif}";
  #       }

  #       button:focus {
  #         background-color: ${mantle};
  #       }

  #       button:hover {
  #         background-color: ${surface0};
  #       }
  #     '';
  #   };
}
