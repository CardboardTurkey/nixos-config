{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiran = {
    isNormalUser = true;
    home = "/home/kiran";
    description = "Kiran Ostrolenk";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  environment.shells = with pkgs; [ bash zsh ];
}
