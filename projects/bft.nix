{ lib, ... }:

let
  bft_dir = "$HOME/gitlab/kiran-rust-course/project";
in

{
  home-manager.users.kiran = { pkgs, lib, ... }: {
    programs.zsh = {
      dirHashes = {
        bft = "${bft_dir}";
      };
    };
    home.activation = {
      bft-setup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! [ -d "${bft_dir}" ] 
        then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone git@gitlab.com:kiran-rust-course/project.git ${bft_dir}
        fi
      '';
    };
  };
}