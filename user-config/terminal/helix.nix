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
