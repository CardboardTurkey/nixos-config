{
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
        error_symbol = "[🤌](bold red)";
      };
      # Should be the default but for some reason an extra right space gets
      # added.
      nix_shell.symbol = "❄️ ";
    };
  };
}
