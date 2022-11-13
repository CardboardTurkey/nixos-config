{ pkgs, ... }:
{
  home-manager.users.kiran = {
    home.file.".icons/default".source = "${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors";
  };
}
