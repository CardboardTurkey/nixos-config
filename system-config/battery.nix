{
  # For the future
  # services.logind.settings.Login = {
  #   HandleLidSwitchExternalPower = "ignore";
  #   HandleLidSwitchDocked = "ignore";
  #   HandleLidSwitch = "suspend-then-hibernate";
  # };

  services.logind = {
    lidSwitchDocked = "ignore";
    lidSwitch = "suspend-then-hibernate";
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=6h";
  # Battery threshold
  services.tlp = {
    enable = true;
    settings = {
      # disable turbo boost on battery
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 95;
    };
  };
}
