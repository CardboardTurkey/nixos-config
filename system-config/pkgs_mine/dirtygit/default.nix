{ pkgs, lib, rustPlatform, ... }:
rustPlatform.buildRustPackage rec {
  pname = "dirtygit";
  name = "dirtygit";
  # version = "0.1.0";

  src = fetchTarball "https://gitlab.com/CardboardTurkey/dirtygit/-/archive/master/dirtygit-master.tar.gz";

  buildInputs = [ pkgs.git ];

  cargoSha256 = "sha256-hq7Jb0hsNTXjoc/s7QFlUPTog2gMmYpRjAo1c/RLBGY=";

  meta = with lib; {
    description = "Track which local git repos have changes that need pushing";
    homepage = "https://gitlab.com/cardboardturkey/dirtygit";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };
}
