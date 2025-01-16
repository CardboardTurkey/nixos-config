{ pkgs, osConfig, ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [
        "${pkgs.${osConfig.file_manager}}/share/applications/pcmanfm.desktop"
      ];
    };
  };
}
