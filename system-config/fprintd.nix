{ ... }:

{
  # Fingerprint scanning
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.i3lock.fprintAuth = true; 
}