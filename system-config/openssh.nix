{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.StreamLocalBindUnlink = true;
  };
  environment.systemPackages = with pkgs; [ waypipe ];

  users.users.kiran.openssh.authorizedKeys.keys = [
    "${config.pgp_auth_2_ssh}"
    "${config.pgp_auth_ssh}"
  ];
}
