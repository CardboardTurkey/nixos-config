{ lib, ... }:

{
  imports = 
    [
      ./bft.nix
      ./flashcard.nix
      ./pdgid.nix
      ./website/src.nix
    ];
}
