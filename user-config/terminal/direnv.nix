_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      # enableNushellIntegration = true;
    };
  };
}
