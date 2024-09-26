{
  description = "You're nixed son";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
  };
  outputs = { self, nixpkgs, nixos-hardware, nix-index-database, home-manager
    , apple-silicon, catppuccin, catppuccin-vsc }:
    let
      shared_modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        nix-index-database.nixosModules.nix-index
        catppuccin.nixosModules.catppuccin
        { nixpkgs.overlays = [ catppuccin-vsc.overlays.default ]; }
      ];
    in {
      nixosConfigurations = {
        mini = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = shared_modules ++ [
            apple-silicon.nixosModules.default
            ./machines/mini/machine-config.nix
            ./machines/mini/hardware-configuration.nix
            {
              home-manager.extraSpecialArgs = {
                catppuccin-hm = catppuccin.homeManagerModules.catppuccin;
              };

            }
          ];
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
            {
              home-manager.extraSpecialArgs = {
                catppuccin-hm = catppuccin.homeManagerModules.catppuccin;
              };
            }
          ];
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

