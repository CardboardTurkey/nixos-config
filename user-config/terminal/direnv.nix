{
  services.lorri.enable = true;
  home-manager.users.kiran = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      # enableNushellIntegration = true;
    };
    services.lorri = {
      enable = true;
      enableNotifications = true;
    };
  };
}
