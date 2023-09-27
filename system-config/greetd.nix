{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "kiran";
      };
    };
  };
  programs.regreet = {
    enable = true;
  };
}
