{ lib, ... }:

let
  web_dir = "$HOME/gitlab/cardboardturkey/website";
in

{
  home-manager.users.kiran = { pkgs, lib, ... }: {
    programs.zsh = {
      dirHashes = {
        web = "${web_dir}";
      };
    };
    home.activation = {
      web-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! [ -d "${web_dir}" ] 
        then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@gitlab.com:CardboardTurkey/website.git ${web_dir}
        fi
      '';
    };
  };
}