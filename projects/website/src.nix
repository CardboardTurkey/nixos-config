{ lib, config, ... }:

{
  home-manager.users.kiran = { pkgs, lib, ... }: {
    programs.zsh = {
      dirHashes = {
        web = "${config.web_dir}";
      };
    };
    home.activation = {
      web-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! [ -d "${config.web_dir}" ] 
        then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@gitlab.com:CardboardTurkey/website.git ${config.web_dir}
        fi
      '';
    };
  };
}