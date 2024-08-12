{
  home-manager.users.kiran = { pkgs, ... }: {
    home.file.".icons/default".source =
      "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
  };
}
