{ pkgs, lib, rustPlatform, fetchFromGitLab, ... }:
rustPlatform.buildRustPackage rec {
  pname = "thing-of-the-day";
  name = "thing-of-the-day";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "CardboardTurkey";
    repo = "thing-of-the-day";
    rev = version;
    sha256 ="sha256-41QnxFwhcvVFdO3I47RJBZnvK0Ag8OlRpBAZq8aZxTc=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];

  cargoSha256 ="sha256-12sUQ98PUOq0va3wikErcHsJno0D8p/2Sy2+wScywkE=";

  meta = with lib; {
    description = "Display word-of-the-day and news headline at regular intervals";
    homepage = "https://gitlab.com/CardboardTurkey/thing-of-the-day";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };

}
