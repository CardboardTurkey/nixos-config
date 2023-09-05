{
  # Enable yubikey with `pamu2cfg > ~/.config/Yubico/u2f_keys`
  # Add second with `pamu2cfg -n >> ~/.config/Yubico/u2f_keys`
  # Then scrap your password: `sudo passwd -d kiran`
  security.pam = {
    services = {
      login = {
        allowNullPassword = true;
      };
      sudo = {
        allowNullPassword = true;
      };
      swaylock = {
        allowNullPassword = true;
      };
      greetd = {
        allowNullPassword = true;
      };
    };
    u2f = {
      enable = true;
      control = "required";
    };
  };
}
