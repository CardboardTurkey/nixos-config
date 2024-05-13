{ pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      StreamLocalBindUnlink = true;
    };
  };
  environment.systemPackages = with pkgs; [
    waypipe
  ];
}
