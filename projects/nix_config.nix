{ lib, ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    programs.zsh = {
      dirHashes = {
        nix   = "$HOME/gitlab/cardboardturkey/nixos-config";
      };
    };
  };
}