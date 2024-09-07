{ pkgs, lib, rustPlatform, ... }:
rustPlatform.buildRustPackage rec {
  pname = "dirtygit";
  name = "dirtygit";
  # version = "0.1.0";

  src = fetchTarball
    "https://gitlab.com/CardboardTurkey/dirtygit/-/archive/master/dirtygit-master.tar.gz";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl pkgs.git ];

  cargoHash = "sha256-jRVK+WE9kCOtU1w3TZK0OSDjIZGHWA3Bo5XFbXf+3iM=";

  meta = with lib; {
    description = "Track which local git repos have changes that need pushing";
    homepage = "https://gitlab.com/cardboardturkey/dirtygit";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };

}
