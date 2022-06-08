{ pkgs, ... }:

{

  imports =
    [
      ../laptop_common.nix
    ];

  # For touch-to-click
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  environment.systemPackages = with pkgs; [
    gimp
  ];
}
