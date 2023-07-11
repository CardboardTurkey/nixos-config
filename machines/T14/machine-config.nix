{ pkgs, ... }:

{

  imports =
    [
      ../laptop_common.nix
    ];

  # For touch-to-click
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  email = "kiran.ostrolenk@codethink.co.uk";
  eth = "enp0s31f6";
  wlan = "wlp0s20f3";
  battery = "BAT0";
  adapter = "AC";
  edp1 = "00ffffffffffff0009e5c90700000000011c0104a51e117802fb90955d59942923505400000001010101010101010101010101010101393780de703814403020360035ad1000001a2d2c80de703814403020360035ad1000001a000000fe00424f452043510a202020202020000000fe004e5631343046484d2d4e34380a0078";
  root = "d0ad36ad-4630-4764-ae08-a8c3e788d521";
  dual_monitor_left = [ "DP-3" "DP-4" ];
  dual_monitor_right = [ "DP-5" "DP-7" ];
  hostname = "Harrier";
  home-manager.users.kiran.programs.git.extraConfig.credential = { helper = "store"; };
  users.users.kiran.extraGroups = [ "dialout" ];
  wallpapers = {
    single = "/home/kiran/Pictures/Wallpapers/flying_marsh_harrier.jpg";
    dual = {
      left = "/home/kiran/Pictures/Wallpapers/Polar_Bear/left.jpg";
      right = "/home/kiran/Pictures/Wallpapers/Polar_Bear/right.jpg";
    };
  };

  # Need fs.office.codethink.co.uk entry added to /root/.ssh/known_hosts
  # and a key without passphrase. This isn't a security issue as you need
  # to be on the office network to access fs anyway.
  environment.systemPackages = [ pkgs.sshfs ];
  # user@host:/remote/path /local/path  fuse.sshfs noauto,x-systemd.automount,_netdev,users,idmap=user,IdentityFile=/home/user/.ssh/id_rsa,allow_other,reconnect 0 0
  fileSystems."/fs" =
    {
      device = "kiranostrolenk@fs.office.codethink.co.uk:/home/users/kiranostrolenk/public_html";
      fsType = "fuse.sshfs";
      noCheck = true;
      options = [
        "noauto"
        "x-systemd.automount"
        "_netdev"
        "users"
        "idmap=user"
        "IdentityFile=/home/kiran/.ssh/id_ed25519_fs"
        "allow_other"
        "reconnect"
        "debug"
      ];
    };

}
