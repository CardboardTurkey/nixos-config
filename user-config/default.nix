{
  config,
  userModPaths,
  pkgs,
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

  # tmp fix for zed rust build
  environment.systemPackages = with pkgs; [
    openssl
    pkg-config
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
