{ pkgs, ... }:
with pkgs; {
  scripts = callPackage ./scripts { inherit pkgs; };
  logiops = callPackage ./logiops { inherit pkgs; };
  dirtygit = callPackage ./dirtygit { inherit pkgs; };
  thing-of-the-day = callPackage ./thing-of-the-day { inherit pkgs; };
  newrust = callPackage ./newrust { inherit pkgs; };
  pyup = callPackage ./pyup { inherit pkgs; };
  colorful_loop = callPackage ./colorful_loop { inherit pkgs; };
}
