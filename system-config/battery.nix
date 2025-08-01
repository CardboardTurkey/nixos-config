{
  services.logind = {
    # lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
    # lidSwitch = "suspend-then-hibernate";
    lidSwitch = "suspend";
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=24h";
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
