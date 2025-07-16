{ pkgs, ... }:
{
  home = {
    sessionVariables.BROWSER = "firefox";
    packages = [ pkgs.vdhcoapp ];
  };
  programs.firefox = {
    enable = true;
    profiles.default.extensions.force = true;
  };
}
