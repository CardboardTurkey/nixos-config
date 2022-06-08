{ lib, ... }:

let
  pdg_dir = "$HOME/gitlab/cardboardturkey/pdgid";
in

{
  home-manager.users.kiran = { pkgs, lib, ... }: {
    programs.zsh = {
      dirHashes = {
        pdg = "${pdg_dir}";
      };
    };
    home.activation = {
      pdgid-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! [ -d "${pdg_dir}" ] 
        then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@gitlab.com:CardboardTurkey/pdgid.git ${pdg_dir}
        fi
      '';
    };
  };
}