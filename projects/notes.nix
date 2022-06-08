{ lib, ... }:

let
  notes_dir = "$HOME/ct-gitlab/codethings/kiranostrolenk/notes";
in

{
  home-manager.users.kiran = { pkgs, lib, ... }: {
    programs.zsh = {
      dirHashes = {
        notes  = "${notes_dir}";
      };
    };
    home.activation = {
      notes-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! [ -d "${notes_dir}" ] 
        then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@gitlab.codethink.co.uk:kiranostrolenk/notes.git ${notes_dir}
        fi
      '';
    };
  };
}