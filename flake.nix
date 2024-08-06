{
  description = "You're nixed son";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
    nixpkgs-unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, nixos-hardware, nixpkgs-unstable, nix-index-database }:
    let
      shared_modules = [
        ./configuration.nix
        nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
    in {
      nixosConfigurations = {
        mini = nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";
          modules = shared_modules ++ [
            ./machines/mini/machine-config.nix
            ./machines/mini/hardware-configuration.nix
          ];
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable { system = "${system}"; };
          };
        };
        P14s = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = shared_modules ++ [
            ./machines/P14s/machine-config.nix
            ./machines/P14s/hardware-configuration.nix
          ];
        };
        XPS = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = shared_modules ++ [
            ./machines/XPS/machine-config.nix
            ./machines/XPS/hardware-configuration.nix
            nixos-hardware.nixosModules.dell-xps-15-7590
          ];
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable { inherit system; };
          };
        };
        pi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = shared_modules ++ [
            ./machines/pi/machine-config.nix
            ./machines/pi/hardware-configuration.nix
          ];
        };
      };
    };
}

