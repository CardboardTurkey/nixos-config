{ pkgs, lib, fetchFromGitLab, rustPlatform, ... }:
rustPlatform.buildRustPackage rec {
  pname = "dirtygit";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "cardboardturkey";
    repo = pname;
    rev = version;
    sha256 = "sha256-/Wk8Y5fvPkiNE5lHAZheyDQ1h+cwBp4jeNi7ZeHpzTM=";
  };

  buildInputs = [ pkgs.git ];

  cargoSha256 = "sha256-r8UJ5kuiOBNfkD6R2n35ztVP+p5oJ9x+vI1iXbWj2zk=";

  meta = with lib; {
    description = "Track which local git repos have changes that need pushing";
    homepage = "https://gitlab.com/cardboardturkey/dirtygit";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
  };
}
