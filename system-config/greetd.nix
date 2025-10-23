{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # `--remember` doesn't work and I don't understand why :(
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --cmd Hyprland";
        # For the future
        # command = "${pkgs.tuigreet}/bin/tuigreet --remember --cmd Hyprland";
        user = "kiran";
      };
    };
  };
}
