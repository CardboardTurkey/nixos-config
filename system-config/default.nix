{ ... }:

{
  imports = 
    [
      ./x11_keyboard.nix
      ./encryption.nix
      ./xserver.nix
      ./battery.nix
      ./font.nix
      ./fprintd.nix
      ./packages.nix
      ./users.nix
      ./boring_stuff.nix
      ./tailscale.nix
    ];
}
