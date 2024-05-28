{ pkgs, config, ... }:

let
  password = "passwords/${config.hostname}";
in

{
  imports = [ ./../user-config/other/sops.nix ];
  sops.secrets."${password}" = { };

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
        # nix shell nixpkgs\#mkpasswd -c mkpasswd -m sha-512
        hashedPasswordFile =
          config.sops.secrets."${password}".path;
      };
    };
  };
  users.groups.kiran = { };
  environment.shells = with pkgs; [ bash zsh ];
}
