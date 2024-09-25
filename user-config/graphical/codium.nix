{ pkgs, osConfig, ... }:
let
  codium-extensions = (with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    tamasfe.even-better-toml
    catppuccin.catppuccin-vsc
    rust-lang.rust-analyzer
    serayuzgur.crates
    streetsidesoftware.code-spell-checker
    vadimcn.vscode-lldb
    mkhl.direnv
    xaver.clang-format
    zhwu95.riscv
    davidanson.vscode-markdownlint
    thenuprojectcontributors.vscode-nushell-lang
    redhat.vscode-xml
    asciidoctor.asciidoctor-vscode
    # techtheawesome.rust-yew
    waderyan.gitblame
    # ms-python.python
    # ms-vscode.cpptools
    # ms-vscode.cmake-tools
    mattn.lisp
    gitlab.gitlab-workflow
    redhat.vscode-yaml
    stkb.rewrap
    nvarner.typst-lsp
    tomoki1207.pdf
    timonwong.shellcheck
    usernamehw.errorlens

  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "yuck";
      publisher = "eww-yuck";
      version = "0.0.3";
      sha256 = "sha256-DITgLedaO0Ifrttu+ZXkiaVA7Ua5RXc4jXQHPYLqrcM=";
    }
    {
      name = "insta";
      publisher = "mitsuhiko";
      version = "1.0.7";
      sha256 = "sha256-2Z7uEenvZ39kcPRE+dvl0G/Wjxm5Pp+RPRn/gRhuM6I=";
    }
  ];

in {
  home.packages = with pkgs; [ clang-tools ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = codium-extensions;
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
      "files.autoSave" = "afterDelay";
      "editor.fontSize" = osConfig.font_size_medium;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font'";
      "editor.formatOnSave" = true;
      "editor.inlayHints.fontSize" = osConfig.font_size_small;
      "editor.fontLigatures" = true;
      "update.mode" = "none";
      "debug.allowBreakpointsEverywhere" = true;
      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nixd}/bin/nixd";
        serverSettings = {
          nixd = {
            formatting = { command = [ "${pkgs.nixfmt-classic}/bin/nixfmt" ]; };
          };
        };
      };
      rust-analyzer = {
        checkOnSave.command = "clippy";
        server.extraEnv = {
          CARGO_TARGET_DIR = "target/rust-analyzer";
          RUSTUP_TOOLCHAIN = "stable";
        };
        check.extraArgs = [ "--target-dir=target/rust-analyzer" ];
      };
      "redhat.telemetry.enabled" = false;
      "window.titleBarStyle" = "custom";
      "explorer.confirmDelete" = false;
      cSpell = {
        language = "en,en-GB";
        userWords = [ "Kiran" "Ostrolenk" "scrutinee" ];
      };
      shellcheck.customArgs = [ "-x" ];
    };
  };
}
