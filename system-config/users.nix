{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiran = {
    isNormalUser = true;
    home = "/home/kiran";
    description = "Kiran Ostrolenk";
    shell = pkgs.zsh;
    extraGroups = [ "kiran" "wheel" ]; # Enable ‘sudo’ for the user.
  };
  users.groups.kiran = { };
  environment.shells = with pkgs; [ bash zsh ];

  # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235/2
  # Need to disable mutable users first though
  # users.users.root.hashedPassword = "!";

}
