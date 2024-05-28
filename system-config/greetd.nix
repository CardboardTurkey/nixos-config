{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # `--remember` doesn't work and I don't understand why :(
        command =
          "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --cmd Hyprland";
        user = "kiran";
      };
    };
  };
}
