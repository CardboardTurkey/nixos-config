{ pkgs, lib, config, ... }:

let

  codium-extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    tamasfe.even-better-toml
    arcticicestudio.nord-visual-studio-code
    # ms-python.python
    matklad.rust-analyzer
    serayuzgur.crates
    streetsidesoftware.code-spell-checker
    vadimcn.vscode-lldb
    arrterian.nix-env-selector
    xaver.clang-format
    zhwu95.riscv
    davidanson.vscode-markdownlint
    thenuprojectcontributors.vscode-nushell-lang
    ms-vscode.cpptools
    ms-vscode.cmake-tools
    waderyan.gitblame
    # rems-project.sail
  ];

in

{
  environment.systemPackages = with pkgs; [
    rnix-lsp
  ];

  home-manager.users.kiran = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = codium-extensions;
      userSettings = {
        "workbench.colorTheme" = "Nord";
        "files.autoSave" = "afterDelay";
        "editor.fontSize" = "${config.font_size_medium}";
        "editor.fontFamily" = "'Hasklug Nerd Font'";
        "editor.formatOnSave" = true;
        "editor.inlayHints.fontSize" = "${config.font_size_small}";
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
