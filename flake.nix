{
  description = "You're nixed son";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
    # nixpkgs-unstable = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-hardware, nix-index-database, home-manager
    , apple-silicon }:
    let
      shared_modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        nix-index-database.nixosModules.nix-index
      ];
    in {
      nixosConfigurations = {
        mini = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = shared_modules ++ [
            apple-silicon.nixosModules.default
            ./machines/mini/machine-config.nix
            ./machines/mini/hardware-configuration.nix
          ];
          # specialArgs = {
          #   pkgs-unstable = import nixpkgs-unstable { system = "${system}"; };
          # };
        };
        P14s = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = shared_modules ++ [
            ./machines/P14s/machine-config.nix
            ./machines/P14s/hardware-configuration.nix
          ];
        };
        XPS = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = shared_modules ++ [
            ./machines/XPS/machine-config.nix
            ./machines/XPS/hardware-configuration.nix
            nixos-hardware.nixosModules.dell-xps-15-7590
          ];
          # specialArgs = {
          #   pkgs-unstable = import nixpkgs-unstable { inherit system; };
          # };
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

