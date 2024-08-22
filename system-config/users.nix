{ pkgs, config, ... }:

let password = "passwords/${config.hostname}";

in {
  imports = [ ./../system-config/sops.nix ];
  sops.secrets."${password}".neededForUsers = true;
  # Define a user account.
  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "!";
      kiran = {
        isNormalUser = true;
        home = "/home/kiran";
        description = "Kiran Ostrolenk";
        shell = pkgs.zsh;
        extraGroups = [ "kiran" "wheel" ]; # Enable ‘sudo’ for the user.
        # nix shell nixpkgs\#mkpasswd -c mkpasswd
        hashedPasswordFile = config.sops.secrets."${password}".path;
      };
      choochoo = {
        isNormalUser = true;
        home = "/home/choochoo";
        description = "Anon";
        shell = pkgs.zsh;
        extraGroups = [ "choochoo" "wheel" ]; # Enable ‘sudo’ for the user.
        # nix shell nixpkgs\#mkpasswd -c mkpasswd
        hashedPasswordFile = config.sops.secrets."${password}".path;
      };
    };
  };
  users.groups.kiran = { };
  users.groups.choochoo = { };
  environment.shells = with pkgs; [ bash zsh ];
}
