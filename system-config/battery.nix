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
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 95;
    };
  };
}
