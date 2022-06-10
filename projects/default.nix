{ lib, ... }:

{
  imports = 
    [
      ./bft.nix
      ./flashcard.nix
      ./nix_config.nix
      ./pdgid.nix
      ./website/src.nix
    ];
}
