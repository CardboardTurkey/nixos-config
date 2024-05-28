{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pcmanfm ];
  services.gvfs.enable = true;
}
