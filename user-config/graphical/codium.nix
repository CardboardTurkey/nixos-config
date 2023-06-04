{ pkgs, lib, config, ... }:

let

  codium-extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    tamasfe.even-better-toml
    arcticicestudio.nord-visual-studio-code
    matklad.rust-analyzer
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
  ];

in

{
  environment.systemPackages = with pkgs; [
    rnix-lsp
  ];

  # allowed_unfree = [ "vscode-extension-ms-vscode-cpptools" ];

  home-manager.users.kiran = { pkgs, ... }: {
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
        "workbench.colorTheme" = "Nord";
        "files.autoSave" = "afterDelay";
        "editor.fontSize" = config.font_size_medium;
        "editor.fontFamily" = "'Hasklug Nerd Font'";
        "editor.formatOnSave" = true;
        "editor.inlayHints.fontSize" = config.font_size_small;
        "editor.fontLigatures" = true;
        "update.mode" = "none";
        "debug.allowBreakpointsEverywhere" = true;
        "nix.enableLanguageServer" = true;
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[markdown]" = {
          "editor.wordWrap" = "wordWrapColumn";
          "editor.wordWrapColumn" = 80;
        };
        "rust-analyzer.checkOnSave.command" = "clippy";
      };
    };
  };
}
