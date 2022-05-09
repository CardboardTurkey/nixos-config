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
	# Turn off bold for the icons on Rust, Python and Nix
	# Need to do this because annoyingly on my setup they're rendered as Font
	# Awesome icons instead of emojis
	rust = {
	  symbol = " ";
	  format = "via [$symbol](red)[($version )]($style)";
	};
	python = {
	  symbol = "🐍 ";
	  format = "via [$symbol](yellow)[($version )]($style)";
	};
	nix_shell = {
	  symbol = "❄ ";
	  format = "via [$symbol](blue)[$state( \($name\))]($style) ";
	};
      };
    };
  };
}
