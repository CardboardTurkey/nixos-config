{ config, lib, pkgs, ... }:

let
  myCustomLayout = pkgs.writeText "symbols/us-kiran" ''
      xkb_symbols "us-kiran"
      {
        include "us(basic)"
        key <BKSL> {    [ backslash, asciitilde ]   };
        key <TLDE> {    [       bar, grave      ]   };
      };
    '';
in

{
  environment.systemPackages = with pkgs; [
    xorg.xkbcomp
  ];
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.extraLayouts.us-kiran = {
    description = "US layout but a bit fucked";
    languages   = [ "eng" ];
    symbolsFile = "${myCustomLayout}";
  };
  services.xserver.layout = "us-kiran";
}
