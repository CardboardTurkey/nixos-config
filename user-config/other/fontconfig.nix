{ ... }:

{
  home-manager.users.kiran = { pkgs, ... }: {
    xdg.configFile."fontconfig/fonts.conf".source = ../files/fontconfig/fonts.conf;
  };
}
