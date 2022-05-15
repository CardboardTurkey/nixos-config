{ config, lib, pkgs, ... }:

let
  myCustomLayout = pkgs.writeText "symbols/us+" ''
      xkb_symbols "us+"
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
  services.xserver = { 
    layout = "us+";
    extraLayouts."us+" = {
      description = "US layout but a bit fucked";
      languages   = [ "eng" ];
      symbolsFile = "${myCustomLayout}";
    };
    xkbOptions = "ctrl:nocaps";
  };
}
