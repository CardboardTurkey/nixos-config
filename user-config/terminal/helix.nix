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
            # TODO: try out these other servers
            # "vale"
            # "marksman"
            {
              name = "efm";
              only-features = [ "diagnostics" ];
            }
          ];
          file-types = [
            "md"
            "mdx"
          ];
        }
      ];
      language-server = {
        rust-analyzer.config.check.command = "clippy";
        efm.command = lib.getExe pkgs.efm-langserver;
        nixd.command = lib.getExe pkgs.nixd;
      };
    };
    settings = {
      editor = {
        line-number = "relative";

        # For version 25.01:
        #
        # # Minimum severity to show a diagnostic after the end of a line:
        # end-of-line-diagnostics = "hint";
        # inline-diagnostics = {
        #   # Minimum severity to show a diagnostic on the primary cursor's line.
        #   # Note that `cursor-line` diagnostics are hidden in insert mode.
        #   cursor-line = "error";
        #   # Minimum severity to show a diagnostic on other lines:
        #   # other-lines = "error"
        # };
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

  xdg.configFile."efm-langserver/config.yaml".text = lib.generators.toYAML { } {
    version = 2;
    languages = {
      markdown = [
        {
          lint-command = "${lib.getExe pkgs.markdownlint-cli} -s";
          lint-stdin = true;
          lint-after-open = true;
          lint-on-save = true;
          lint-formats = [
            "%f:%l %m"
            "%f:%l:%c %m"
            "%f: %l: %m"
          ];
        }
      ];
    };
  };
}
