_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.keychain = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      keys = [ "id_ed25519" ];
    };
  };
}
