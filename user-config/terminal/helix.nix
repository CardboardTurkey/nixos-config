{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  home.sessionVariables.EDITOR = "hx";
  catppuccin.helix.useItalics = true;
  xdg.configFile = {
    "helix/themes/my-theme.toml".text = ''
      inherits = "catppuccin-${osConfig.flavour}"
      "ui.background" = {}
    '';
  };
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      yaml-language-server
      yamllint
      ansible-lint
    ];
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
            "typos"
          ];
        }
        {
          name = "git-commit";
          language-servers = [
            "marksman"
            "typos"
          ];
        }
        {
          name = "python";
          # Make sure lsp is present in dev env
          language-servers = [
            "pylsp"
          ];
          auto-format = true;
          # formatter = {
          #   command = lib.getExe pkgs.ruff;
          #   args = [
          #     "format"
          #     "-"
          #   ];
          # };
        }
        {
          name = "toml";
          formatter = {
            command = lib.getExe pkgs.taplo;
            args = [
              "fmt"
              "-"
            ];
          };
        }
      ];
      language-server = {
        rust-analyzer.config = {
          check.command = "clippy";
          files.watcher = "server";
        };
        yaml-language-server.config.yaml.customTags = [
          "!vault scalar"
          "!reference sequence"
        ];
        nixd.command = lib.getExe pkgs.nixd;
        marksman.command = lib.getExe pkgs.marksman;
        pylsp = {
          command = "${
            pkgs.python3.withPackages (
              ps: with ps; [
                python-lsp-server
                python-lsp-ruff
              ]
            )
          }/bin/pylsp";
          plugins.ruff = {
            enabled = true;
            formatEnabled = true;
            format = [ "I" ];
          };
        };
        typos.command = lib.getExe pkgs.typos-lsp;
        taplo.command = lib.getExe pkgs.taplo;
      };
    };
    settings = {
      theme = lib.mkForce "my-theme";
      editor = {
        line-number = "relative";
        soft-wrap.enable = true;
        file-picker.hidden = false;

        # Minimum severity to show a diagnostic after the end of a line:
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          # Minimum severity to show a diagnostic on the primary cursor's line.
          # Note that `cursor-line` diagnostics are hidden in insert mode.
          cursor-line = "error";
          # Minimum severity to show a diagnostic on other lines:
          # other-lines = "error"
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          center = [
            # "file-encoding"
            # "file-type"
            # "file-line-ending"
            # "separator"
            "read-only-indicator"
            "version-control"
            "spacer"
            "file-modification-indicator"
          ];
          left = [
            "mode"
            "spinner"
            # "selections"
            # "primary-selection-length"
            # "separator"
            "position"
            "file-name"
            "diagnostics"
          ];
          right = [
            "workspace-diagnostics"
            "spacer"
            "position-percentage"
          ];
        };
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 500;
          };
        };
      };
      keys = {
        insert.j.j = "normal_mode";
        normal = {
          # Reproduce vim `*` and `#`
          "*" = [
            "move_char_right"
            "move_prev_word_start"
            "move_next_word_end"
            "search_selection"
            "make_search_word_bounded"
            "search_next"
          ];
          "#" = [
            "move_char_right"
            "move_prev_word_start"
            "move_next_word_end"
            "search_selection"
            "make_search_word_bounded"
            "search_prev"
          ];
          "@" = [
            "move_char_right"
            "move_prev_word_start"
            "move_next_word_end"
            "search_selection"
            "make_search_word_bounded"
            "global_search"
          ];
          space.space.b = ":sh ${pkgs.git}/bin/git blame -L %{cursor_line},%{cursor_line} %{buffer_name}";
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
          C-g = [
            ":write-all"
            ":insert-output ${lib.getExe pkgs.lazygit} >/dev/tty"
            ":redraw"
            ":reload-all"
          ];
        };
      };
    };
  };
}
