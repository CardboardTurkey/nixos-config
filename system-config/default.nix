{ ... }:

{
  imports = 
    [
      ./x11_keyboard.nix
      ./encryption.nix
      ./xserver.nix
      ./boring_stuff.nix
    ];
}
