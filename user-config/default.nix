{
  config,
  userModPaths,
  ...
}:
{
  # For zsh completion (apparently)
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;

  # Needed by gtk?
  programs.dconf.enable = true;

  # Also need hyprland from system-config

  allowed_unfree = [
    "vscode-extension-github-copilot"
    "vscode-extension-fill-labs-dependi"
  ];

  home-manager = {
    users = {
      kiran = {
        home.stateVersion = "22.11";
        imports = userModPaths config.userModules;
      };
    };
    useGlobalPkgs = true;
  };
}
