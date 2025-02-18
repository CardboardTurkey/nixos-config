{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ hyperfine ];
    shellAliases.time = "use hyperfine!";
  };

  services.pueue = {
    enable = true;
    settings.daemon.default_parallel_tasks = 8;
  };
  programs.bat.enable = true;
}
