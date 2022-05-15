# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# test
# https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134

{ config, pkgs, ... }:

let

  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

in

{
  nixpkgs.overlays = [ (self: super: { local = import ./my-pkgs { pkgs = super; }; }) ];

  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./hardware-extra.nix
      ./core
      (import "${home-manager}/nixos")
      ./user-config
      ./system-config
    ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DejaVuSansMono" "Hasklig" ]; })
    noto-fonts-emoji
    font-awesome
  ];

  # Battery threshold
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiran = {
    isNormalUser = true;
    home = "/home/kiran";
    description = "Kiran Ostrolenk";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    firefox
    thunderbird
    pass
    wl-clipboard
    quasselClient
    ripgrep
    zip
    unzip
    rustup
    gcc
    local.scripts
    local.logiops
    htop
    feh
    arandr
    brightnessctl
    flameshot
    pciutils
    usbutils
    signal-desktop
    xorg.xev
    xorg.xmodmap
  ];

  # For zsh completion
  environment.pathsToLink = [ "/share/zsh" ];

  # Fingerprint scanning
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.i3lock.fprintAuth = true; 

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

