{ pkgs, lib, ... }:
{
  home.sessionVariables.EDITOR = "hx";
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

        {
          name = "markdown";
          language-servers = [
            "marksman"
          ];
        }
        {
          name = "python";
          # Make sure lsp is present in dev env
          language-servers = [
            "pylsp"
            "ruff"
          ];
          formatter.command = "${lib.getExe pkgs.ruff} check --select I --fix - | ${lib.getExe pkgs.ruff} format -";
        }
      ];
      language-server = {
        rust-analyzer.config = {
          check.command = "clippy";
          files.watcher = "server";
        };
        nixd.command = lib.getExe pkgs.nixd;
        marksman.command = lib.getExe pkgs.marksman;
        ruff.command = lib.getExe pkgs.ruff;
      };
    };
    settings = {
      editor = {
        line-number = "relative";
        soft-wrap.enable = true;

        # Minimum severity to show a diagnostic after the end of a line:
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          # Minimum severity to show a diagnostic on the primary cursor's line.
          # Note that `cursor-line` diagnostics are hidden in insert mode.
          cursor-line = "error";
          # Minimum severity to show a diagnostic on other lines:
          # other-lines = "error"
        };
      };
      keys.normal = {
        space.w = ":w";
        space.q = ":q";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };
  };
}
