{ _ }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.zsh = {
      dirHashes = {
        notes  = "$HOME/ct-gitlab/codethings/kiranostrolenk/notes";
      };
    };
  };
}