{ lib, ... }:

with lib;
{
  options = {
    email = mkOption {
      default = "kostrolenk@gmail.com";
      type = with types; uniq str;
      description = "Email address (for git)";
    };
    eth = mkOption {
      default = "lololol";
      type = with types; uniq str;
      description = "Ethernet interface";
    };
    wlan = mkOption {
      default = "wlp59s0";
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
      default = "00ffffffffffff004d10ba1400000000161d0104a52213780ede50a3544c99260f505400000001010101010101010101010101010101ac3780a070383e403020350058c210000018000000000000000000000000000000000000000000fe004d57503154804c513135364d31000000000002410332001200000a010a202000d3";
      type = with types; uniq str;
      description = "Fingerprint for laptop screen";
    };
    root = mkOption {
      default = "a9cd1bf6-feb8-41ad-be79-e85f9827fbb1";
      type = with types; uniq str;
      description = "Root partition id";
    };
    hostname = mkOption {
      default = "kestrel";
      type = with types; uniq str;
      description = "Network hostname";
    };
  };
}
