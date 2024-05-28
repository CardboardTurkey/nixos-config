with import <nixpkgs> { };

let pythonPackages = python3Packages;
in pkgs.mkShell rec {
  name = "pyShell";
  venvDir = "./.venv";
  buildInputs = [
    pythonPackages.python
    pythonPackages.ipython
    pythonPackages.venvShellHook
    ripgrep
  ];

  postVenvCreation = ''
    if cat dev-requirements.txt \
       | sed 's/==.*//' \
       | xargs pip show 2>&1 \
       | rg 'Package\(s\) not found'
    then
      pip install -r dev-requirements.txt
      pip install -e '.[test]'
    fi
  '';

}
