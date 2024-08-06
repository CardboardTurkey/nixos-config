{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [ comma ];
  home-manager.users.kiran = { pkgs, ... }: {
    programs.command-not-found.enable = true;
  };
}
