_:

{
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  # home-manager.users.kiran = { pkgs, lib, ... }: {
  #   systemd.user.services.mpris-proxy = {
  #     Unit.Description = "Mpris proxy";
  #     Unit.After = [ "network.target" "sound.target" ];
  #     Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  #     Install.WantedBy = [ "default.target" ];
  #   };
  # };
}
