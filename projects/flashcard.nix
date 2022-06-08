{ _ }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.zsh = {
      dirHashes = {
        flash = "$HOME/gitlab/cardboardturkey/flashcard";
      };
    };
  };
}