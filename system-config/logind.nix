_:
{
  services.logind = { 
    # lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
    extraConfig = ''
    IdleActionUSec=infinity
    IdleActionSec=infinity
    '';
  };
}
