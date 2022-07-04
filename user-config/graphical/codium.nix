{ pkgs, lib, ... }:

let

  codium-extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    tamasfe.even-better-toml
    arcticicestudio.nord-visual-studio-code
    ms-python.python
    matklad.rust-analyzer
    serayuzgur.crates
    streetsidesoftware.code-spell-checker
    vadimcn.vscode-lldb
    b4dm4n.vscode-nixpkgs-fmt
  ];

in

{

  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
  ];

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
        "editor.inlayHints.fontSize" = 15;
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
      };
    };
  };
}
