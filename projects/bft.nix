{ _ }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.zsh = {
      dirHashes = {
        bft  = "$HOME/gitlab/kiran-rust-course/project";
      };
    };
  };
}