{ config, lib, pkgs, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
        };
	rust = {
	  symbol = " ";
	  format = "via [$symbol](red)[($version )]($style)";
	};
      };
    };
  };
}
