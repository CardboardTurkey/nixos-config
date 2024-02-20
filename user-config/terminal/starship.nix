{
  home-manager.users.kiran = {
    programs.nushell.enable = true;
    programs.bash.enable = true;
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      settings = {
        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
        };
        nix_shell = {
          symbol = "❄ ";
        };
        aws = {
          symbol = "☁️ ";
        };
      };
    };
  };
}
