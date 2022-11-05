{ pkgs, lib, ... }:

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
        "editor.fontSize" = 20;
        "editor.fontFamily" = "'Hasklug Nerd Font'";
        "editor.formatOnSave" = true;
        "editor.inlayHints.fontSize" = 15;
        "editor.fontLigatures" = true;
        "update.mode" = "none";
        "debug.allowBreakpointsEverywhere" = true;
        "nix.enableLanguageServer" = true;
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "rust-analyzer.checkOnSave.command" = "clippy";
      };
    };
  };
}
