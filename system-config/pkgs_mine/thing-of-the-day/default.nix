{ pkgs, lib, rustPlatform, ... }:
rustPlatform.buildRustPackage rec {
  pname = "thing-of-the-day";
  name = "thing-of-the-day";
  # version = "0.1.0";

  src = fetchTarball "https://gitlab.com/CardboardTurkey/thing-of-the-day/-/archive/master/thing-of-the-day-master.tar.gz";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl pkgs.git ];

  cargoSha256 = "sha256-J5ogQOixHCHox4Jdhh7j1CWWmCG9ELh1Cll716jXz40=";

  meta = with lib; {
    description = "Display word-of-the-day and news headline at regular intervals";
    homepage = "https://gitlab.com/CardboardTurkey/thing-of-the-day";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };

}
