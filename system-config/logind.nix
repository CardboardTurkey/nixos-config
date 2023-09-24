{
  services.logind = { 
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
    # This doesn't do anything, can probably yeet
    extraConfig = ''
    IdleActionUSec=infinity
    IdleActionSec=infinity
    '';
  };
}
