{
  stdenv,
  fetchgit,
  lib,
  ...
}:

stdenv.mkDerivation {
  name = "spinner";
  version = "unstable-2025-04-22";

  src = fetchgit {
    url = "https://gitlab.com/CardboardTurkey/spinner.git";
    rev = "d22a4bc1a4f115a84cbb76aee3c7a2f143208345";
    sha256 = "sha256-q5moiSGmvDOljBzLUSiFrptOPyqV73wsiD/IAMRBSfc=";
  };

  buildInputs = [ stdenv ];

  configurePhase = ''
    install_path=$out/bin
    mkdir -p $install_path
  '';

  installPhase = ''
    cp -r spinner $install_path
  '';

  meta = {
    description = "Simple shell spinner";
    longDescription = ''
      Print a spinner to stdout while waiting for a shell command to finish.
    '';
    homepage = "https://gitlab.com/CardboardTurkey/spinner/";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.CardboardTurkey ];
    platforms = lib.platforms.linux;
  };
}
