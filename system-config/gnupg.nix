{ config, lib, ... }:

{
  # Not sure what this is
  # Is it conflicting with keychain?
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}