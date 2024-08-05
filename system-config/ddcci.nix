# DCC/CI
#
# For brightness control.

{ config, pkgs, ... }:
{

  boot.extraModulePackages = with config.boot.kernelPackages; [
    ddcci-driver
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
