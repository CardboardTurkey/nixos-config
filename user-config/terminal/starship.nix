_:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
        };
        nix_shell = {
          symbol = "❄ ";
        };
      };
    };
  };
}
