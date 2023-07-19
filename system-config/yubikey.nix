{ pkgs, ...}:

{
  systemd.packages = [ pkgs.yubikey-touch-detector ];
  systemd.user.services.yubikey-touch-detector = {
    enable = true;
    path = with pkgs; [ gnupg ];
  };
  systemd.user.sockets.yubikey-touch-detector = {
    enable = true;
  };

}
