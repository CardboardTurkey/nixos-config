{ pkgs, ... }:
with pkgs; {
  scripts = callPackage ./scripts { inherit pkgs; };
  logiops = callPackage ./logiops { inherit pkgs; };
}
