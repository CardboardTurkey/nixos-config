{ config, lib, pkgs, ... }:

let

  codium-extensions = (with pkgs.vscode-extensions; [
        bbenoist.nix
	tamasfe.even-better-toml
        arcticicestudio.nord-visual-studio-code
        ms-python.python
        matklad.rust-analyzer
	serayuzgur.crates
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }
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
      };
    };
  };
}
