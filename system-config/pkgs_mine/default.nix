{ pkgs, ... }:
with pkgs; {
  scripts = callPackage ./scripts { inherit pkgs; };
  logiops = callPackage ./logiops { inherit pkgs; };
  dirtygit = callPackage ./dirtygit { inherit pkgs; };
  thing-of-the-day = callPackage ./thing-of-the-day { inherit pkgs; };
  rustup = callPackage ./rustup { inherit pkgs; };
  pyup = callPackage ./pyup { inherit pkgs; };
  nordzy-cursor-theme = callPackage ./nordzy-cursor-theme { inherit pkgs; };
}
