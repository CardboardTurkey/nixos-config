{
  description = "You're nixed son";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-24.05"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
  };
  outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations = {
      mini = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
          ./machines/mini/machine-config.nix
          ./machines/mini/hardware-configuration.nix
        ];
      };
      P14s = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./machines/P14s/machine-config.nix
          ./machines/P14s/hardware-configuration.nix
        ];
      };
      XPS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./machines/XPS/machine-config.nix
          ./machines/XPS/hardware-configuration.nix
          nixos-hardware.nixosModules.dell-xps-15-7590
        ];
      };
      pi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
          ./machines/pi/machine-config.nix
          ./machines/pi/hardware-configuration.nix
        ];
      };
    };
  };
}

