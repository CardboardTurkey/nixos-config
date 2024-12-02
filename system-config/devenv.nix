{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ devenv ];
  nix.extraOptions = ''
    trusted-users = root kiran
  '';
}
