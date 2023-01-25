{ pkgs, ... }:

{

  imports =
    [
      ../laptop_common.nix
    ];

  # For touch-to-click
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

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
