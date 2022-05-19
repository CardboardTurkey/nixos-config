{ pkgs, ... }:

let
  myCustomLayout = pkgs.writeText "symbols/ko" ''
      xkb_symbols "ko"
      {
        include "us(basic)"

        key <BKSL> {	[ backslash, asciitilde ]	};
        key <TLDE> {    [       bar, grave      ]	};

	key <CAPS> {	[ Control_L, Control_L	]	};
	replace key <LCTL> {	[ Hyper_L ]	};
	modifier_map Control { <CAPS> };
	modifier_map Mod5    { <LCTL> };
      };
    '';
in

{
  environment.systemPackages = with pkgs; [
    xorg.xkbcomp
  ];
  services.xserver = { 
    layout = "ko";
    extraLayouts."ko" = {
      description = "US layout but a bit fucked";
      languages   = [ "eng" ];
      symbolsFile = "${myCustomLayout}";
    };
  };
}
