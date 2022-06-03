{ pkgs, lib, ... }:

let

  codium-extensions = (with pkgs.vscode-extensions; [
        bbenoist.nix
        tamasfe.even-better-toml
        arcticicestudio.nord-visual-studio-code
        ms-python.python
        matklad.rust-analyzer
        serayuzgur.crates
        vadimcn.vscode-lldb
        streetsidesoftware.code-spell-checker
        ms-vscode-remote.remote-ssh
      ]);

in

{

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode-extension-ms-vscode-remote-remote-ssh"
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
      };
    };
  };
}
