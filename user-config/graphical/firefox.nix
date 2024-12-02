{
  home.sessionVariables.BROWSER = "firefox";
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";
    };
  };
}
