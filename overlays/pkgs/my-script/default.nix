{ stdenv, lib, pkgs, ... }:

let

  myScript = pkgs.writeTextFile {
    name = "my-script";
    executable = true;
    destination = "/bin/my-script.sh";
    text = ''
        echo hello world
    '';
  };
in stdenv.mkDerivation rec {
  pname = "my-script";
  version = "0.0.1";

  # Copy the script defined in the `let` statement above into the final
  # derivation.
  #
  buildInputs = [ myScript ];
  builder = pkgs.writeTextFile {
    name = "builder.sh";
    text = ''
      . $stdenv/setup
      mkdir -p $out/bin
      ln -sf ${myScript}/bin/my-script.sh $out/bin/my-script.sh
    '';
  };
}
