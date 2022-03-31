{ config, pkgs, lib, ...}:

with lib;
{
  options = {
    eth = mkOption {
      default = "enp0s31f6";
      type = with types; uniq str;
      description = "Ethernet interface";
    };
    wlan = mkOption {
      default = "wlp0s20f3";
      type = with types; uniq str;
      description = "Wireless interface";
    };
    battery = mkOption {
      default = "BAT0";
      type = with types; uniq str;
      description = "As given in /sys/class/power_supply/";
    };
    adapter = mkOption {
      default = "AC";
      type = with types; uniq str;
      description = "As given in /sys/class/power_supply/";
    };
    edp1 = mkOption {
      default = "00ffffffffffff0009e5c90700000000011c0104a51e117802fb90955d59942923505400000001010101010101010101010101010101393780de703814403020360035ad1000001a2d2c80de703814403020360035ad1000001a000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e34380a0078";
      type = with types; uniq str;
      description = "Fingerprint for laptop screen";
    };
    root = mkOption {
      default = "d0ad36ad-4630-4764-ae08-a8c3e788d521";
      type = with types; uniq str;
      description = "Root partition id";
    };
  };
}