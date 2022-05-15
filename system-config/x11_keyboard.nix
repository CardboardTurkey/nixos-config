{ pkgs, ... }:

let
  myCustomLayout = pkgs.writeText "symbols/mia" ''
      xkb_symbols "mia"
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
    layout = "mia";
    extraLayouts."mia" = {
      description = "US layout but a bit fucked";
      languages   = [ "eng" ];
      symbolsFile = "${myCustomLayout}";
    };
    xkbOptions = "ctrl:nocaps";
  };
}
