{ _ }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.zsh = {
      dirHashes = {
        pdg   = "$HOME/gitlab/cardboardturkey/pdgid";
      };
    };
  };
}