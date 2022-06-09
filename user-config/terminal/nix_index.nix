_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    # nix-index
    programs.command-not-found.enable = true;
  };
}
