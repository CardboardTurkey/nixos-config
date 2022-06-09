_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.keychain = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
