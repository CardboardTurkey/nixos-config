{ config, lib, pkgs, ... }:

let
  myCustomLayout = pkgs.writeText "xkb-layout" ''
    keycode 51 = backslash asciitilde
    keycode 49 = bar grave
  '';
in

{
  environment.systemPackages = with pkgs; [
    xorg.xkbcomp
  ];
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${myCustomLayout}";
}
