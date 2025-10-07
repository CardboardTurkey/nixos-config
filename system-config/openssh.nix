{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      # Dont remember, probably for connection persistence
      StreamLocalBindUnlink = true;
      # Security hardening
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "kiran" ];
    };
  };

  services.fail2ban.enable = true;

  environment.systemPackages = with pkgs; [ waypipe ];

  users.users.kiran.openssh.authorizedKeys.keys = [
    "${config.pgp_auth_2_ssh}"
    "${config.pgp_auth_ssh}"
  ];
}
