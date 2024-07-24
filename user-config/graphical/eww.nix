{ pkgs, ... }:
let
  open-bar = pkgs.writeScript "eww-open-bar" ''
    #! ${pkgs.runtimeShell}

    export XDG_RUNTIME_DIR=/run/user/$UID

    # For some reason the eww daemon needs to started from a genuine kiran shell
    # - as opposed to one entered by root via `su`. No idea why.
    timeout 10 bash -c "while ! ${pkgs.eww}/bin/eww ping;do :;done" && ${pkgs.eww}/bin/eww open bar
  '';
in {
  # I don't think this rule was ever much use and is possibly slowing down shutdown.

  # Would be nice if the username wasn't hard coded
  # services.udev.extraRules = ''
  #   ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.su}/bin/su kiran -c ${open-bar}"
  # '';

  fonts.packages = with pkgs; [ material-icons linearicons-free ];

  home-manager.users.kiran = { pkgs, ... }: {
    programs.eww = {
      enable = true;
      configDir = ../files/eww;
    };
  };
}
