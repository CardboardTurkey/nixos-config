with import <nixpkgs> { };

let
  pythonPackages = python3Packages;
in
pkgs.mkShell rec {
  name = "pdgid";
  venvDir = "./.venv";
  buildInputs = [
    pythonPackages.python
    pythonPackages.venvShellHook
    ripgrep
  ];

  postShellHook = ''
    if cat dev-requirements.txt \
       | sed 's/==.*//' \
       | xargs pip show pdgid 2>&1 \
       | rg 'Package\(s\) not found'
    then
      pip install -r dev-requirements.txt
      pip install -e '.[test]'
    fi
  '';

}
