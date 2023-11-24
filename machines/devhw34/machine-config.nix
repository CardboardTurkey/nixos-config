{ pkgs, config, ... }:

{

  imports =
    [
      ../pc_common.nix
    ];

  email = "kiran.ostrolenk@codethink.co.uk";
  eth = "eno1";
  root = "5f3d43dc-1955-4eae-955a-1d151d08fcfc";
  dual_monitor_left = [ "DP-1" ];
  dual_monitor_right = [ "DP-2" ];
  hostname = "devhw34";
  home-manager.users.kiran = {
    programs.zsh.dirHashes = {
      lorry = "$HOME/gitlab/CodethinkLabs/lorry/lorry2/";
    };
  };
  wallpapers = {
    single = "/home/kiran/Pictures/Wallpapers/ice_breaker.jpg";
    dual = {
      left = "/home/kiran/Pictures/Wallpapers/Polar_Bear/left.jpg";
      right = "/home/kiran/Pictures/Wallpapers/Polar_Bear/right.jpg";
    };
  };

  users.users.kiran.extraGroups = [ "docker" ];

  # Project change
  boot.kernel.sysctl = { "kernel.perf_event_paranoid" = 0; };

  powerManagement.cpuFreqGovernor = "performance";

}
