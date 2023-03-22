{ pkgs, lib, rustPlatform, fetchFromGitLab, ... }:
rustPlatform.buildRustPackage rec {
  pname = "thing-of-the-day";
  name = "thing-of-the-day";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "CardboardTurkey";
    repo = "thing-of-the-day";
    rev = version;
    hash = "sha256-XJ0BGxQ1B3YCMSNz6O1HThxRBim9Ahz6OTtuH4Drj58=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];

  cargoSha256 = "sha256-1qyTdIkUcSkae3F2sZTkkXsXr2QSVT93ic7C3q0yvQs=";

  meta = with lib; {
    description = "Display word-of-the-day and news headline at regular intervals";
    homepage = "https://gitlab.com/CardboardTurkey/thing-of-the-day";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };

}
