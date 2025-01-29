{ pkgs, lib, ... }:
{
  programs.helix = {
    enable = true;
    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
          language-servers = [ "nixd" ];
        }
      ];
      language-server = {
        rust-analyzer.config.check.command = "clippy";
        nixd.command = lib.getExe pkgs.nixd;
      };
    };
  };
}
