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
      default = "00ffffffffffff005a6322f5010101010814010380341d782eeed5a555489b26125054bfef80d1c0b300a9409500904081808140714f023a801871382d40582c450009252100001e000000ff005239533130303830303333330a000000fd00324b165211000a202020202020000000fc00564732343237574d0a2020202000bd";
      type = with types; uniq str;
      description = "Fingerprint for laptop screen";
    };
  };
}