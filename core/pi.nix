{ lib, ...}:

with lib;
{
  options = {
    email = mkOption {
      default = "kostrolenk@gmail.com";
      type = with types; uniq str;
      description = "Email address (for git)";
    };
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
    root = mkOption {
      default = "coming soon";
      type = with types; uniq str;
      description = "Root partition id";
    };
    hostname = mkOption {
      default = "wren";
      type = with types; uniq str;
      description = "Network hostname";
    };
  };
}
