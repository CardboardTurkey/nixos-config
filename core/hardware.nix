{ lib, ... }:

with lib;
{
  options = {
    eth = mkOption {
      default = "eth0";
      type = with types; uniq str;
      description = "Ethernet interface";
    };
    wlan = mkOption {
      default = "wlan0";
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
      default = "";
      type = with types; uniq str;
      description = "Fingerprint for laptop screen";
    };
    root = mkOption {
      default = "";
      type = with types; uniq str;
      description = "Root partition id";
    };
    dual_monitor_left = mkOption {
      default = [ "dual_monitor_left" ];
      type = with types; listOf str;
      description = "The left monitors in dual monitor setup";
    };
    dual_monitor_right = mkOption {
      default = [ "dual_monitor_right" ];
      type = with types; listOf str;
      description = "The right monitors in dual monitor setup";
    };
  };
}
