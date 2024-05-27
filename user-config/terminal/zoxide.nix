{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fzf
  ];
  home-manager.users.kiran = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      options = [ "--cmd" "cd" ];
    };
  };
}
