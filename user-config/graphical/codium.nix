{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
let
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  codium-extensions =
    (with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      tamasfe.even-better-toml
      (catppuccin.catppuccin-vsc.override {
        accent = osConfig.accent;
        customUIColors = {
          all = {
            "statusBar.foreground" = "accent";
            "statusBar.noFolderForeground" = "accent";
          };
        };
      })
      catppuccin.catppuccin-vsc-icons
      rust-lang.rust-analyzer
      fill-labs.dependi
      streetsidesoftware.code-spell-checker
      vadimcn.vscode-lldb
      mkhl.direnv
      xaver.clang-format
      zhwu95.riscv
      davidanson.vscode-markdownlint
      thenuprojectcontributors.vscode-nushell-lang
      asciidoctor.asciidoctor-vscode
      mattn.lisp
      gitlab.gitlab-workflow
      redhat.vscode-yaml
      redhat.vscode-xml
      stkb.rewrap
      # nvarner.typst-lsp got removed
      tomoki1207.pdf
      timonwong.shellcheck
      usernamehw.errorlens
      ms-dotnettools.vscode-dotnet-runtime # needed by devskim
      zxh404.vscode-proto3
      # github.copilot
    ])
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "yuck";
        publisher = "eww-yuck";
        version = "0.0.3";
        sha256 = "sha256-DITgLedaO0Ifrttu+ZXkiaVA7Ua5RXc4jXQHPYLqrcM=";
      }
      {
        name = "vscode-devskim";
        publisher = "ms-cst-e";
        version = "1.0.52";
        sha256 = "sha256-f5U8/t669aGV5bHsdxY6U1WPzLuzUxqkaHZBSqrGULU=";
      }
      {
        name = "insta";
        publisher = "mitsuhiko";
        version = "1.0.7";
        sha256 = "sha256-2Z7uEenvZ39kcPRE+dvl0G/Wjxm5Pp+RPRn/gRhuM6I=";
      }
      {
        name = "yamlfmt";
        publisher = "bluebrown";
        version = "0.1.6";
        sha256 = "sha256-a+bIpgLHHcPJd2DEEenTP2jZKlT9fz039U/O+IGZf4c=";
      }
    ];

in
{
  home.packages = with pkgs; [
    clang-tools
    (patchDesktop vscodium "codium" "^Name=VSCodium" "Name=Codium")
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = codium-extensions;
    mutableExtensionsDir = false;
    languageSnippets = {
      rust = {
        "New Yew function component" = {
          prefix = "yewfc";
          body = [
            "#[derive(PartialEq, Properties)]"
            "pub struct \${1:ComponentName}Props {}"
            ""
            "#[function_component]"
            "pub fn $1(props: &\${1}Props) -> Html {"
            "    let \${1}Props {} = props;"
            "    html! {"
            "        <\${2:div}>$0</\${2}>"
            "    }"
            "}"
          ];
          "description" = "Create a minimal Yew function component";
        };
        "New Yew struct component" = {
          "prefix" = "yewsc";
          "body" = [
            "pub struct \${1:ComponentName};"
            ""
            "pub enum \${1}Msg {"
            "}"
            ""
            "impl Component for \${1} {"
            "    type Message = \${1}Msg;"
            "    type Properties = ();"
            ""
            "    fn create(ctx: &Context<Self>) -> Self {"
            "        Self"
            "    }"
            ""
            "    fn view(&self, ctx: &Context<Self>) -> Html {"
            "        html! {"
            "            $0"
            "        }"
            "    }"
            "}"
          ];
          "description" = "Create a new Yew component with a message enum";
        };
      };
    };
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Frappé";
      "workbench.iconTheme" = "catppuccin-${osConfig.flavour}";

      # Catppuccin recommendations
      # we try to make semantic highlighting look good
      editor.semanticHighlighting.enabled = true;
      # prevent VSCode from modifying the terminal colors
      terminal.integrated.minimumContrastRatio = 1;
      # make the window's titlebar use the workbench colors
      window.titleBarStyle = "custom";
      # applicable if you use Go, this is an opt-in flag!
      gopls = {
        ui.semanticTokens = true;
      };

      "explorer.confirmDragAndDrop" = false;
      "files.autoSave" = "afterDelay";
      editor = {
        fontSize = osConfig.font_size_medium;
        fontFamily = "'JetBrainsMono Nerd Font'";
        formatOnSave = true;
        inlayHints.fontSize = osConfig.font_size_small;
        fontLigatures = true;
        bracketPairColorization.enabled = true;
        guides.bracketPairs = "active";
        guides.bracketPairsHorizontal = true;
      };
      "update.mode" = "none";
      "debug.allowBreakpointsEverywhere" = true;
      "dotnetAcquisitionExtension.existingDotnetPath" = [
        {
          "extensionId" = "MS-CST-E.vscode-devskim";
          "path" = "${lib.getExe pkgs.dotnetCorePackages.sdk_8_0_3xx}";
        }
      ];
      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nixd}/bin/nixd";
        serverSettings = {
          nixd = {
            formatting = {
              command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
          };
        };
      };
      yaml.customTags = [
        "!reference sequence"
        "!vault scalar"
      ];
      rust-analyzer = {
        checkOnSave = true;
        server.extraEnv = {
          CARGO_TARGET_DIR = "${config.cargo_target_dir}/rust-analyzer";
          RUSTUP_TOOLCHAIN = "stable";
        };
        check = {
          extraArgs = [ "--target-dir=${config.cargo_target_dir}/rust-analyzer" ];
          command = "clippy";
        };
      };
      "redhat.telemetry.enabled" = false;
      "window.titleBarStyle" = "custom";
      "explorer.confirmDelete" = false;
      cSpell = {
        language = "en,en-GB";
        userWords = [
          "Kiran"
          "Ostrolenk"
          "scrutinee"
          "nixpkgs"
          "nixos"
          "devenv"
          "cachix"
          "pkgs"
          "sbuk"
          "serde"
          "ratatui"
          "crossterm"
          "joypixels"
          "rustup"
          "clippy"
          "shellcheck"
          "nixfmt"
          "nixd"
          "catppuccin"
          "insta"
          "riscv"
          "direnv"
          "dejavu"
          "fira"
          "hasklig"
          "smoothbrained"
        ];
      };
      shellcheck.customArgs = [ "-x" ];
    };
    keybindings = [
      {
        key = "ctrl+r";
        command = "commandId";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+r";
        command = "editor.action.rename";
        when = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
      }
      {
        key = "f2";
        command = "-editor.action.rename";
        when = "editorHasRenameProvider && editorTextFocus && !editorReadonly";
      }
    ];
  };
}
