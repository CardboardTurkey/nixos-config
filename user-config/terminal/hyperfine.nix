{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ hyperfine ];
    shellAliases.time = "use hyperfine!";
  };
}
