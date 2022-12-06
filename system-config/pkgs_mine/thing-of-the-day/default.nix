{ pkgs, lib, rustPlatform, fetchFromGitLab, ... }:
rustPlatform.buildRustPackage rec {
  pname = "thing-of-the-day";
  name = "thing-of-the-day";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "CardboardTurkey";
    repo = "thing-of-the-day";
    rev = version;
    # sha256 = lib.fakeSha256;
    sha256 = "sha256-iG+1NELUVkn0O8Uh2Z8mQ0DzwHF0EA8wJKk/kVQFzw4=";
  };
  # src = fetchTarball "https://gitlab.com/CardboardTurkey/thing-of-the-day/-/archive/master/thing-of-the-day-master.tar.gz";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];

  # cargoSha256 = lib.fakeSha256;
  cargoSha256 = "sha256-32ww+SN23dxBHrjo/PKC4MhoyID9hLH9kZMjNU353Vs=";

  meta = with lib; {
    description = "Display word-of-the-day and news headline at regular intervals";
    homepage = "https://gitlab.com/CardboardTurkey/thing-of-the-day";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };

}
