{ config, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      StreamLocalBindUnlink = true;
    };
  };
}
