{ config, ... }:
{
  catppuccin = {
    enable = true;
    flavor = config.flavour;
  };
}
