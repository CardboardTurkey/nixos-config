{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./nord.nix
      ./hardware.nix
    ];
}