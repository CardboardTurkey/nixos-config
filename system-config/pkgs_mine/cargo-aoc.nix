{ lib, fetchFromGitHub, rustPlatform, pkgs, ... }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-aoc";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "gobanos";
    repo = pname;
    rev = version;
    hash = "sha256-tHuT/dsiyliXdl34bFraYp3T3FUgxFnhEUQfc8O197I=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];

  cargoHash = "sha256-lUQwwGJLHLI9bfJiLUUE8j1svBAgbvr+8hKB/bRzwNA=";

  meta = with lib; {
    description = "cargo-aoc is a simple CLI tool that aims to be a helper for the Advent of Code";
    homepage = "https://github.com/gobanos/cargo-aoc";
    license = licenses.unlicense; # No license
    maintainers = [ ];
  };
}
