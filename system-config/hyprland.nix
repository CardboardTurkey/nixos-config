{ pkgs, ... }: {
  environment = {
    # Optional, hint electron apps to use wayland
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      pipewire # needed for screen sharing
      wireplumber # needed for screen sharing
      slurp
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
      libsForQt5.qt5ct
      xwayland
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
}
