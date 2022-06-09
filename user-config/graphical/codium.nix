{ pkgs, lib, ... }:

let

  codium-extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        tamasfe.even-better-toml
        arcticicestudio.nord-visual-studio-code
        ms-python.python
        matklad.rust-analyzer
        serayuzgur.crates
        streetsidesoftware.code-spell-checker
      ];

in

{

  home-manager.users.kiran = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = codium-extensions;
      userSettings = {
        "workbench.colorTheme" = "Nord";
        "editor.fontSize" = 20;
        "editor.fontFamily" = "'Hasklug Nerd Font'";
        "update.mode" = "none";
        "[nix]"."editor.tabSize" = 2;
        "editor.fontLigatures" = true;
        "debug.allowBreakpointsEverywhere" = true;
      };
    };
  };
}
