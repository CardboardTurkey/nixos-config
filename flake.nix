{
  description = "You're nixed son";

  inputs = { nixpkgs = { url = "github:cardboardturkey/nixpkgs/nixos-unstable"; }; };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
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

