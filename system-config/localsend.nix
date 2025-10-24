{ pkgs, ... }:
{

  allowed_unfree = [
    "jocalsend"
  ];
  environment.systemPackages = with pkgs; [ jocalsend ];
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
