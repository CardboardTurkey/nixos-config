{
  home-manager.users.kiran.services.batsignal = {
    enable = true;
    extraArgs = [ "-I battery-caution" ];
  };
}
