{ catppuccin-hm, osConfig, ... }: {
  imports = [ catppuccin-hm ];
  catppuccin = {
    enable = true;
    flavor = osConfig.flavour;
    accent = osConfig.accent;
  };
}
