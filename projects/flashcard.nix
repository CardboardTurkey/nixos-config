{ lib, ... }:

let
  flash_dir = "$HOME/gitlab/cardboardturkey/flashcard";
in

{
  home-manager.users.kiran = { pkgs, lib, ... }: {
    programs.zsh = {
      dirHashes = {
        flash = "${flash_dir}";
      };
    };
    home.activation = {
      flash-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! [ -d "${flash_dir}" ] 
        then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@gitlab.com:CardboardTurkey/flashcard.git ${flash_dir}
        fi
      '';
    };
  };
}