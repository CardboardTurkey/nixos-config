{ lib, ... }:

{
  imports = 
    [
      ./bft.nix
      ./flashcard.nix
      ./nix_config.nix
      ./notes.nix
      ./pdgid.nix
    ];
}
